ruleset show_form {
    meta {
        name "lab 3"
        author "Jacob Wright"
        logging off
    }

   rule watch_rule {
        select when pageview ".*" setting ()
        pre {
            watch_link = <<
            <div>
                <a id='watched' href="javascript:void(0)">
                    Watched
                </a>
            </div>
            >>;
        }
        {
            append('body', watch_link);
            watch("#watched", "click");
        }
    }
}