package com.bladecoder.ink.runtime;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

/**
 * Encompasses all the global variables in an ink Story, and allows binding of a
 * VariableChanged event so that that game code can be notified whenever the
 * global variables change.
 */
public class VariablesState implements Iterable<String> {

	public static interface VariableChanged {
		void variableStateDidChangeEvent(String variableName, RTObject newValue) throws Exception;
	}

	private boolean batchObservingVariableChanges;

	// Used for accessing temporary variables
	private CallStack callStack;

	private HashSet<String> changedVariables;

	private HashMap<String, RTObject> globalVariables;
	private HashMap<String, RTObject> defaultGlobalVariables;

	private VariableChanged variableChangedEvent;

	private ListDefinitionsOrigin listDefsOrigin;

	VariablesState(CallStack callStack, ListDefinitionsOrigin listDefsOrigin) {
		globalVariables = new HashMap<String, RTObject>();
		this.callStack = callStack;

		this.listDefsOrigin = listDefsOrigin;
	}

	CallStack getCallStack() {
		return callStack;
	}

	void setCallStack(CallStack callStack) {
		this.callStack = callStack;
	}

	public void assign(VariableAssignment varAss, RTObject value) throws Exception {
		String name = varAss.getVariableName();
		int contextIndex = -1;
		// Are we assigning to a global variable?
		boolean setGlobal = false;
		if (varAss.isNewDeclaration()) {
			setGlobal = varAss.isGlobal();
		} else {
			setGlobal = globalVariables.containsKey(name);
		}

		// Constructing new variable pointer reference
		if (varAss.isNewDeclaration()) {
			VariablePointerValue varPointer = value instanceof VariablePointerValue ? (VariablePointerValue) value
					: (VariablePointerValue) null;
			if (varPointer != null) {
				VariablePointerValue fullyResolvedVariablePointer = resolveVariablePointer(varPointer);
				value = fullyResolvedVariablePointer;
			}

		} else {
			// Assign to existing variable pointer?
			// Then assign to the variable that the pointer is pointing to by
			// name.
			// De-reference variable reference to point to
			VariablePointerValue existingPointer = null;
			do {
				existingPointer = getRawVariableWithName(name, contextIndex) instanceof VariablePointerValue
						? (VariablePointerValue) getRawVariableWithName(name, contextIndex)
						: (VariablePointerValue) null;
				if (existingPointer != null) {
					name = existingPointer.getVariableName();
					contextIndex = existingPointer.getContextIndex();
					setGlobal = (contextIndex == 0);
				}

			} while (existingPointer != null);
		}
		if (setGlobal) {
			setGlobal(name, value);
		} else {
			callStack.setTemporaryVariable(name, value, varAss.isNewDeclaration(), contextIndex);
		}
	}

	ListDefinitionsOrigin getLists() {
		return listDefsOrigin;
	}

	void copyFrom(VariablesState toCopy) {
		globalVariables = new HashMap<String, RTObject>(toCopy.globalVariables);

		// It's read-only, so no need to create a new copy
		defaultGlobalVariables = toCopy.defaultGlobalVariables;

		setVariableChangedEvent(toCopy.getVariableChangedEvent());

		if (toCopy.getbatchObservingVariableChanges() != getbatchObservingVariableChanges()) {
			if (toCopy.getbatchObservingVariableChanges()) {
				batchObservingVariableChanges = true;
				changedVariables = new HashSet<String>(toCopy.changedVariables);
			} else {
				batchObservingVariableChanges = false;
				changedVariables = null;
			}
		}

	}

	RTObject tryGetDefaultVariableValue(String name) {
		RTObject val = defaultGlobalVariables.get(name);

		return val;
	}

	public Object get(String variableName) {
		RTObject varContents = null;

		// Search main dictionary first.
		// If it's not found, it might be because the story content has changed,
		// and the original default value hasn't be instantiated.
		// Should really warn somehow, but it's difficult to see how...!
		if ((varContents = globalVariables.get(variableName)) != null) {
			return ((Value<?>) varContents).getValue();
		} else if ((varContents = defaultGlobalVariables.get(variableName)) != null) {
			return ((Value<?>) varContents).getValue();
		} else
			return null;
	}

	public boolean getbatchObservingVariableChanges() {
		return batchObservingVariableChanges;
	}

	// Make copy of the variable pointer so we're not using the value direct
	// from
	// the runtime. Temporary must be local to the current scope.
	// 0 if named variable is global
	// 1+ if named variable is a temporary in a particular call stack element
	int getContextIndexOfVariableNamed(String varName) {
		if (globalVariables.containsKey(varName))
			return 0;

		return callStack.getCurrentElementIndex();
	}

	public HashMap<String, Object> getjsonToken() throws Exception {
		return Json.hashMapRuntimeObjsToJObject(globalVariables);
	}

	RTObject getRawVariableWithName(String name, int contextIndex) throws Exception {
		RTObject varValue = null;
		// 0 context = global
		if (contextIndex == 0 || contextIndex == -1) {
			varValue = globalVariables.get(name);
			if (varValue != null) {
				return varValue;
			}

			ListValue listItemValue = listDefsOrigin.findSingleItemListWithName(name);
			if (listItemValue != null)
				return listItemValue;
		}

		// Temporary
		varValue = callStack.getTemporaryVariableWithName(name, contextIndex);

		return varValue;
	}

	void snapshotDefaultGlobals() {
		defaultGlobalVariables = new HashMap<String, RTObject>(globalVariables);
	}

	public RTObject getVariableWithName(String name) throws Exception {
		return getVariableWithName(name, -1);
	}

	RTObject getVariableWithName(String name, int contextIndex) throws Exception {
		RTObject varValue = getRawVariableWithName(name, contextIndex);
		// Get value from pointer?
		VariablePointerValue varPointer = varValue instanceof VariablePointerValue ? (VariablePointerValue) varValue
				: (VariablePointerValue) null;
		if (varPointer != null) {
			varValue = valueAtVariablePointer(varPointer);
		}

		return varValue;
	}

	/**
	 * Enumerator to allow iteration over all global variables by name.
	 */
	@Override
	public Iterator<String> iterator() {
		return globalVariables.keySet().iterator();
	}

	// Given a variable pointer with just the name of the target known, resolve
	// to a variable
	// pointer that more specifically points to the exact instance: whether it's
	// global,
	// or the exact position of a temporary on the callstack.
	VariablePointerValue resolveVariablePointer(VariablePointerValue varPointer) throws Exception {
		int contextIndex = varPointer.getContextIndex();
		if (contextIndex == -1)
			contextIndex = getContextIndexOfVariableNamed(varPointer.getVariableName());

		RTObject valueOfVariablePointedTo = getRawVariableWithName(varPointer.getVariableName(), contextIndex);
		// Extra layer of indirection:
		// When accessing a pointer to a pointer (e.g. when calling nested or
		// recursive functions that take a variable references, ensure we don't
		// create
		// a chain of indirection by just returning the final target.
		VariablePointerValue doubleRedirectionPointer = valueOfVariablePointedTo instanceof VariablePointerValue
				? (VariablePointerValue) valueOfVariablePointedTo
				: (VariablePointerValue) null;
		if (doubleRedirectionPointer != null) {
			return doubleRedirectionPointer;
		} else {
			return new VariablePointerValue(varPointer.getVariableName(), contextIndex);
		}
	}

	public void set(String variableName, Object value) throws Exception {

		// This is the main
		if (!defaultGlobalVariables.containsKey(variableName)) {
			 throw new StoryException ("Cannot assign to a variable ("+variableName+") that hasn't been declared in the story");
		}

		AbstractValue val = AbstractValue.create(value);
		if (val == null) {
			if (value == null) {
				throw new StoryException("Cannot pass null to VariableState");
			} else {
				throw new StoryException("Invalid value passed to VariableState: " + value.toString());
			}
		}

		setGlobal(variableName, val);
	}

	public void setbatchObservingVariableChanges(boolean value) throws Exception {
		batchObservingVariableChanges = value;
		if (value) {
			changedVariables = new HashSet<String>();
		} else {
			if (changedVariables != null) {
				for (String variableName : changedVariables) {
					RTObject currentValue = globalVariables.get(variableName);
					getVariableChangedEvent().variableStateDidChangeEvent(variableName, currentValue);
				}
			}

			changedVariables = null;
		}
	}

	void retainListOriginsForAssignment(RTObject oldValue, RTObject newValue) {
		ListValue oldList = null;

		if (oldValue instanceof ListValue)
			oldList = (ListValue) oldValue;

		ListValue newList = null;

		if (newValue instanceof ListValue)
			newList = (ListValue) newValue;

		if (oldList != null && newList != null && newList.value.size() == 0)
			newList.value.setInitialOriginNames(oldList.value.getOriginNames());
	}

	void setGlobal(String variableName, RTObject value) throws Exception {
		RTObject oldValue = globalVariables.get(variableName);

		ListValue.retainListOriginsForAssignment(oldValue, value);

		globalVariables.put(variableName, value);

		if (getVariableChangedEvent() != null && !value.equals(oldValue)) {

			if (getbatchObservingVariableChanges()) {
				changedVariables.add(variableName);
			} else {
				getVariableChangedEvent().variableStateDidChangeEvent(variableName, value);
			}
		}

	}

	public void setjsonToken(HashMap<String, Object> value) throws Exception {
		globalVariables = Json.jObjectToHashMapRuntimeObjs(value);
	}

	public RTObject valueAtVariablePointer(VariablePointerValue pointer) throws Exception {
		return getVariableWithName(pointer.getVariableName(), pointer.getContextIndex());
	}

	public VariableChanged getVariableChangedEvent() {
		return variableChangedEvent;
	}

	public void setVariableChangedEvent(VariableChanged variableChangedEvent) {
		this.variableChangedEvent = variableChangedEvent;
	}

	boolean globalVariableExistsWithName(String name) {
		return globalVariables.containsKey(name);
	}
}
