let backgroundStyleForTopImage = () => {
    ReactDOMRe.Style.make(~width="100%", ~height="auto", ())
}

let imageForStory = (name) => {
    switch (name) {
        | "boat" => "background/boat.jpg"
    }
}

