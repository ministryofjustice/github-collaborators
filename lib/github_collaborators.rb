require "json"
require "net/http"
require "uri"
require_relative "./github_graph_ql_client"
require_relative "./repository_collaborators"
require_relative "./organization"
require_relative "./repositories"

PAGE_SIZE = 100
