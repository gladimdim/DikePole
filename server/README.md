# Generate stories from online catalog:

Create folders:

```
mkdir data
cd data
mkdir built_in_stories
mkdir purgatory
mkdir passed_stories
```
Run generator:
```
dart ./bin/generate_stories.dart
```

Run server at port 9093

```
dart ./bin/server.dart
```

Go to 

http://localhost:9093/catalog
