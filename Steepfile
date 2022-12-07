D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib" # Directory name
  check "Gemfile" # File name
  # check "app/models/**/*.rb" # Glob
  # ignore "lib/templates/*.rb"

  library(
    "pathname",
    "singleton"
  )

  collection_config "rbs_collection.yaml"

  library(
    "hashie",
    "rack"
  )

  configure_code_diagnostics do |hash| # You can setup everything yourself
    hash[D::Ruby::MethodDefinitionMissing] = :hint
  end
end

# target :test do
#   signature "sig", "sig-private"

#   check "test"

#   # library "pathname", "set"       # Standard libraries
# end
