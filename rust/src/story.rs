use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone)]
pub struct Link {
    pub name: String,
    pub link: String,
    pub pid: String
}

#[derive(Serialize, Deserialize, Clone)]
pub struct StoryNode {
    pub text: String,
    pub name: String,
    pub pid: String,
    pub background: String,
    pub links: Option<Vec<Link>>
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Response {
    pub passages: Vec<StoryNode>
}

pub fn get_story_for_id(response: Response, id: String) -> Option<StoryNode> {
    let story:Vec<StoryNode> = response.passages.into_iter().filter(|item| {
        item.pid == id
    }).collect();
    if story.len() == 1 {
        Some(story[0].clone())
    } else {
        None
    }
}