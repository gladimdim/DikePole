#[macro_use]
extern crate seed;
use seed::prelude::*;

use seed::{spawn_local, Method, Request};
use serde::{Deserialize, Serialize};

use futures::Future;

// Model
#[derive(Serialize, Deserialize, Clone)]
struct Link {
    name: String,
    link: String,
    pid: String
}
#[derive(Serialize, Deserialize, Clone)]
struct StoryNode {
    text: String,
    name: String,
    pid: String,
    background: String,
    links: Vec<Link>
}

#[derive(Serialize, Deserialize, Clone)]
struct Response {
    passages: Vec<StoryNode>
}

#[derive(Clone)]
struct Model {
    count: i32,
    what_we_count: String,
    response: Response,
}

// Setup a default here, for initialization later.
impl Default for Model {
    fn default() -> Self {
        Self {
            count: 0,
            what_we_count: "click".into(),
            response: Response{ passages: Vec::new() } 
        }
    }
}
fn get_data(state: seed::App<Msg, Model>) -> impl Future<Item = (), Error = JsValue> {
    let url = "/twinery.json";

    Request::new(url)
        .method(Method::Get)
        .fetch_json()
        .map(move |json| {
            state.update(Msg::SetResponse(json))
        })
}
// Update

#[derive(Clone)]
enum Msg {
    Increment,
    Decrement,
    ChangeWWC(String),
    SetResponse(Response),
    FetchData(seed::App<Msg, Model>)
}

/// The sole source of updating the model; returns a fresh one.
fn update(msg: Msg, model: Model) -> Model {
    match msg {
        Msg::FetchData(state) => {
            spawn_local(get_data(state));
            model
        },
        Msg::SetResponse(response) => Model {
            response: response,
            ..model
        },
        Msg::Increment => Model {
            count: model.count + 1,
            ..model
        },
        Msg::Decrement => Model {
            count: model.count - 1,
            ..model
        },
        Msg::ChangeWWC(what_we_count) => Model {
            what_we_count,
            ..model
        },
    }
}

fn render_text(story: StoryNode) -> El<Msg> {
    div![
        class![], story.text
    ]
}
// View

/// A simple component.

/// The top-level component we pass to the virtual dom.
fn view(state: seed::App<Msg, Model>, model: Model) -> El<Msg> {
    let plural = if model.count == 1 { "" } else { "s" };

    // Attrs, Style, Events, and children may be defined separately.
    let outer_style = style! {
            "display" => "flex";
            "flex-direction" => "column";
            "text-align" => "center"
    };

    let divs:Vec<El<Msg>> = model.response.passages.clone()
                .into_iter()
                .enumerate()
                .map(|(posit, story)| render_text(story))
                .collect();

    div![
        outer_style,
        h1!["The Grand Total"],
        div![
            style! {
                // Example of conditional logic in a style.
                "color" => if model.count > 4 {"purple"} else {"gray"};
                // When passing numerical values to style!, "px" is implied.
                "border" => "2px solid #004422"; "padding" => 20
            },
            // We can use normal Rust code and comments in the view.
            h3![format!(
                "{} {}{} so far",
                model.count, model.what_we_count, plural
            )],
            button![simple_ev("click", Msg::FetchData(state)), "Fetch"],
            divs, 
        ],
    ]
}

#[wasm_bindgen]
pub fn render() {
    seed::run(Model::default(), update, view, "main", None, None);
}
