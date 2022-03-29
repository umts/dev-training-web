var search_data = {"index":{"searchIndex":["applicationassets","applicationconfiguration","devtraining","formattinghelpers","issue","milestone","readme","repository","training","devtrainingapplication","add_collaborator()","add_collaborators!()","asset_path()","body()","content()","create_issues!()","create_readme!()","format_body()","format_checklist()","load!()","new()","new()","new()","new()","new()","new()","new()","resource()","resource()","resource()","resource()","readme"],"longSearchIndex":["applicationassets","applicationconfiguration","devtraining","devtraining::formattinghelpers","devtraining::issue","devtraining::milestone","devtraining::readme","devtraining::repository","devtraining::training","devtrainingapplication","devtraining::repository#add_collaborator()","devtraining::training#add_collaborators!()","applicationassets#asset_path()","devtraining::issue#body()","devtraining::readme#content()","devtraining::training#create_issues!()","devtraining::training#create_readme!()","devtraining::formattinghelpers#format_body()","devtraining::formattinghelpers#format_checklist()","applicationconfiguration::load!()","applicationassets::new()","devtraining::new()","devtraining::issue::new()","devtraining::milestone::new()","devtraining::readme::new()","devtraining::repository::new()","devtraining::training::new()","devtraining::issue#resource()","devtraining::milestone#resource()","devtraining::readme#resource()","devtraining::repository#resource()",""],"info":[["ApplicationAssets","","ApplicationAssets.html","","<p>Wrapper class for our applications&#39;s Sprockets environment.\n"],["ApplicationConfiguration","","ApplicationConfiguration.html","","<p>helper module for loading Figaro configuration in the environment in a non-\nRails application.\n"],["DevTraining","","DevTraining.html","","<p>Contains the classes that represent the various GitHub resources for a\ndeveloper&#39;s training program. ...\n"],["DevTraining::FormattingHelpers","","DevTraining/FormattingHelpers.html","","<p>A few helpers for formatting issue text. Available as module functions\nfor convenience, but also included ...\n"],["DevTraining::Issue","","DevTraining/Issue.html","","<p>Class representing a GitHub issue, lazily instantiated.\n"],["DevTraining::Milestone","","DevTraining/Milestone.html","","<p>Class representing a GitHub milestone, lazily instantiated\n"],["DevTraining::Readme","","DevTraining/Readme.html","","<p>Class representing the “README” file in the training repository. It is\nresponsible for rendering ...\n"],["DevTraining::Repository","","DevTraining/Repository.html","","<p>Class representing the training progress repository, lazily instantiated. It\nis the context that a number ...\n"],["DevTraining::Training","","DevTraining/Training.html","","<p>Main Developer training object, used to coordinate resource creation and\nupdates\n"],["DevTrainingApplication","","DevTrainingApplication.html","","<p>Sinatra application resposible for the web-app-ish components of training creation\n"],["add_collaborator","DevTraining::Repository","DevTraining/Repository.html#method-i-add_collaborator","(login)","<p>Add the GitHub user, <code>login</code> as an outside collaborator on the repository.\n"],["add_collaborators!","DevTraining::Training","DevTraining/Training.html#method-i-add_collaborators-21","(collaborators)","<p>Takes an array of login names and adds them in turn as outside\ncollaborators to the repository.\n"],["asset_path","ApplicationAssets","ApplicationAssets.html#method-i-asset_path","(file, digest: false)","<p>Returns an HTTP path that will resolve to the requested asset. The optional\ndigest: parameter will cause ...\n"],["body","DevTraining::Issue","DevTraining/Issue.html#method-i-body","()","<p>The text of this issue&#39;s body (uses DevTraining::FormattingHelpers.format_body)\n"],["content","DevTraining::Readme","DevTraining/Readme.html#method-i-content","()","<p>The rendered content of the README template. Note that the template is\npassed <code>self</code> with it&#39;s call ...\n"],["create_issues!","DevTraining::Training","DevTraining/Training.html#method-i-create_issues-21","(stream)","<p>Takes an <code>Array</code> of <code>Hash</code>es, each in the format a DevTraining::Issue\nexpects, and returns an <code>Array</code> of resources ...\n"],["create_readme!","DevTraining::Training","DevTraining/Training.html#method-i-create_readme-21","(filename)","<p>Takes a filename that will be passed to a new DevTraining::Readme, and\nthen returns the resource as created ...\n"],["format_body","DevTraining::FormattingHelpers","DevTraining/FormattingHelpers.html#method-i-format_body","(desc, subtasks = nil)","<p>Returns <code>desc</code>, and optionally if <code>subtasks</code> is a non-empty <code>Array</code>, the\nresults of format_checklist tacked ...\n"],["format_checklist","DevTraining::FormattingHelpers","DevTraining/FormattingHelpers.html#method-i-format_checklist","(checklist)","<p>Makes a GFM “tasklisk” with one item per item in <code>checklist</code>\n"],["load!","ApplicationConfiguration","ApplicationConfiguration.html#method-c-load-21","()","<p>Read the <code>config/application.yml</code> file and load it into <code>ENV</code>\n"],["new","ApplicationAssets","ApplicationAssets.html#method-c-new","()","<p>Configure Sprockets&#39; search paths here\n"],["new","DevTraining","DevTraining.html#method-c-new","(...)","<p>Convenience module method. Calling <code>DevTraining.new</code> returns a new\nDevTraining::Training object.\n"],["new","DevTraining::Issue","DevTraining/Issue.html#method-c-new","(client, repo, milestone, data)","<p>Arguments:\n<p><code>client</code>: An <code>Octokit::Client</code>\n<p><code>repo</code>: A DevTraining::Repository\n"],["new","DevTraining::Milestone","DevTraining/Milestone.html#method-c-new","(client, repo)","<p>Takes an <code>Octokit::Client</code> and a DevTraining::Repository\n"],["new","DevTraining::Readme","DevTraining/Readme.html#method-c-new","(filename, client, repo)","<p>Arguments:\n<p><code>filename</code>: The path to a template file or a type that Tilt knows how\n to render\n<p><code>client</code>: An <code>Octokit::Client</code> …\n"],["new","DevTraining::Repository","DevTraining/Repository.html#method-c-new","(client)","<p>Takes an <code>Octokit::Client</code>\n"],["new","DevTraining::Training","DevTraining/Training.html#method-c-new","(token)","<p>Initialized with a GitHub token. In the console, you can use a Personal\nAccess Token, but the Sinatra ...\n"],["resource","DevTraining::Issue","DevTraining/Issue.html#method-i-resource","()","<p>The <code>Sawyer::Resource</code> representing the GitHub issue. It will be found by <code>title</code> and\n<code>milestone</code>, or created ...\n"],["resource","DevTraining::Milestone","DevTraining/Milestone.html#method-i-resource","()","<p>The <code>Sawyer::Resource</code> representing the GitHub milestone. It will be found\nby <code>title</code> or created in the repository ...\n"],["resource","DevTraining::Readme","DevTraining/Readme.html#method-i-resource","()","<p>The <code>Sawyer::Resource</code> representing the contents of the readme if found, or\nthe contents and commit information ...\n"],["resource","DevTraining::Repository","DevTraining/Repository.html#method-i-resource","()","<p>The <code>Sawyer::Resource</code> representing the repository. It will be found by\nname, or created if not found for ...\n"],["README","","README_md.html","","<p>Introduction\n<p>This application is a Sinatra-based web app for authorizing our developer\ntrainees with  ...\n"]]}}