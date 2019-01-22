#[macro_use]
extern crate seed;
use seed::prelude::*;

use seed::{spawn_local, Method, Request};

use futures::Future;

mod story;



#[derive(Clone)]
struct Model {
    current: String,
    response: Option<story::Response>,
}

// Setup a default here, for initialization later.
impl Default for Model {
    fn default() -> Self {
        Self {
            response: None,
            current: "1".to_string(), 

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
    SetResponse(story::Response),
    FetchData(seed::App<Msg, Model>),
    SetCurrent(String)
}

/// The sole source of updating the model; returns a fresh one.
fn update(msg: Msg, model: Model) -> Model {
    match msg {
        Msg::FetchData(state) => {
            spawn_local(get_data(state));
            model
        },
        Msg::SetResponse(response) => Model {
            response: Some(response),
            ..model
        },
        Msg::SetCurrent(current) => Model {
            current: current,
            ..model
        }
    }
}

fn render_story(story: Option<story::StoryNode>) -> El<Msg> {
    match story {
        None => div!["Далі немає гри!"],
        Some(story) => 
            div![
                img![attrs!{"src" => format!("/background/{}_0.jpg", story.background)}, style!{"width" => "100%"; "height" => "auto"}],
                div![story.text],
                (match story.links {
                    None => vec![div!["Це все!"]],
                    Some(links) => {
                        let result:Vec<El<Msg>> = links.into_iter().map(|link: story::Link| {
                            button![simple_ev("click", Msg::SetCurrent(link.pid)), link.name]
                        }).collect();
                        result
                    }
                })
            ]
    }
}
// View

fn view(state: seed::App<Msg, Model>, model: Model) -> El<Msg> {
    // Attrs, Style, Events, and children may be defined separately.
    let outer_style = style! {
            "display" => "flex";
            "flex-direction" => "column";
            "text-align" => "center"
    };

    div![
        outer_style,
        div![
            (match model.response {
                None => button![simple_ev("click", Msg::FetchData(state)), "Розпочати гру"],
                Some(response) => {
                    let story_node = story::get_story_for_id(response, model.current.to_string());
                    render_story(story_node)
                }
            }),
        ],
    ]
}

#[wasm_bindgen]
pub fn render() {
    seed::run(Model::default(), update, view, "main", None, None);
}
