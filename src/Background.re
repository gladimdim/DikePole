let backgroundStyleFor = (img: string) => {
    switch (img) {
        | "boat" => ReactDOMRe.Style.make(~backgroundRepeat="no-repeat", ~backgroundSize="100%", ~opacity="0.4", ~backgroundPosition="center", ~backgroundImage="url(background/boat.jpg)", ())
    }
}
