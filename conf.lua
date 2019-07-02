function love.conf(t)
    t.window.title = "grim gamers 2"
    t.window.minwidth = 1280
    t.window.minheight = 720
    t.console = true

    t.releases = {
        title = "Grim Gamers", -- The project title (string)
        package = nil, -- The project command and package name (string)
        loveVersion = nil, -- The project LÖVE version
        version = nil, -- The project version
        author = "Tom Smallridge", -- Your name (string)
        email = nil, -- Your email (string)
        description = nil, -- The project description (string)
        homepage = nil, -- The project homepage (string)
        identifier = nil, -- The project Uniform Type Identifier (string)
        excludeFileList = {".git", "tests", ".luacheckrc", "README.md", ".vscode", ".circleci", ".gitignore"},
        releaseDirectory = nil -- Where to store the project releases (string)
    }
end
