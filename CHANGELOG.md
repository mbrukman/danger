## Master

* Show appropriate error message when GitHub repo was moved - KrauseFx
* `danger plugins json [gem]` will now give gem metadata too - orta
* Crash fix for `bundle exec danger` - hanneskaeufler
* Fix Buildkite repo slug URL generation - phillfarrugia
* Set LANG variable to en_US.UTF-8 before running git commands - bogren

## 3.0.3

* Add `mr_diff`/`pr_diff` for `Danger::DangerfileGitLabPlugin` - K0nserv
* Fixes a bug where `danger` wouldn't work on Jenkins when setup with the GitHub Pull Request Builder plugin. - vittoriom

## 3.0.2

* Spelling and grammar fixes. - connorshea
* More crash fixes for `danger local`, maybe we need more tests here - orta


## 3.0.1

* Crash fix for `danger local` - hanneskaeufler

## 3.0.0

* GitLab support - k0nserv / deanpcmad / hjanuschka

  This started back in February, and is now shipping. 
  Documentation has been updated on the [Getting Started](http://danger.systems/guides/getting_started.html#creating-a-bot-account-for-danger-to-use) for those interested in the setup.

  This adds a new object to the DSL, `gitlab` which offers the following API:

  ```ruby
  gitlab.mr_title # The title of the Merge Request 

  gitlab.mr_body # The body text of the Merge Request

  gitlab.mr_author # The username of the author of the Merge Request

  gitlab.mr_labels # The labels assigned to the Merge Request

  gitlab.branch_for_merge # The branch to which the MR is going to be merged into

  gitlab.base_commit # The base commit to which the MR is going to be merged as a parent

  gitlab.head_commit # The head commit to which the MR is requesting to be merged from

  gitlab.mr_json # The hash that represents the MR's JSON
  api # Provides access to the GitLab API client used inside Danger

  gitlab.html_link (paths: String or Array, full_path=true: Bool) # Returns a list of HTML anchors for a file, or files in the head repository. 
  ```

  A lot of thanks for the GitLab team also, who helped handle updates for one of our dependencies.

* Adapt CI Sources that support GitLab - k0nserv

* **BREAKING** Removes the implicit Dangerfile support. - orta

  The implicit support was a feature that would check for an `[org]/danger`
  repo, and automatically parse that Dangerfile. Think it was a bit too magic,
  and the only person who I know is using it, said they think it should have 
  been this way from the start. I'm cool with this.

  To handle the replacement, we've added a new object to the DSL.
  This is the `danger` API. It has two responsibilities at the moment,
  downloading a Dangerfile:

  ```ruby
  danger.import_dangerfile = "artsy/danger"
  ```

  and importing local plugins:

  ```ruby
  danger.import_plugin [path_or_url]
  ```

  Which the astute may have remembered used to be the purview of `plugin.import`.
  Which is now removed, in favour of the `danger.import_plugin`. Think there's more
  space for improvement inside the context of `danger` than `plugin`.

  I also removed `plugin.download` - couldn't see a use for it inside a Dangerfile. Happy
  to change that, if it's being used it.

* Rename `DANGER_GITHUB_API_HOST` to `DANGER_GITHUB_API_BASE_URL`. - k0nserv  
  Using `DANGER_GITHUB_API_HOST` is still supported to preserve backwards
  comaptibility, but using `DANGER_GITHUB_API_BASE_URL` is encouraged.

## 2.1.6

* Crash fix for `danger init` - marcelofabri

## 2.1.5

* Lols, more Circle CI stuff, and importantly - more documentation - orta 

## 2.1.4

* Improve detection of PR content on CircleCI. - jamtur01

## 2.1.3

* Improve detection of Buildkite's PR context - cysp
* An attempt at fixing a misalignment with what Danger says is inside the diff range, and what people have seen #160 #316 - orta/yimingtang/jamtur01/segiddins
* Copyedit the README and vision statement - suchow

## 2.1.2

* Improvements to `danger init` - orta
* Circle CI validation improvements - orta

## 2.1.1

* Adds `danger-junit` to the `danger/danger` repo, requiring changes to the plugin testing systems - orta
* Improves the "is a shared Dangerfile from the Danger Repo" check #366 - orta
* Replaces `redcarpet` through `kramdown` to avoid jruby foo - LeFnord

## 2.1.0

* Refactors the CI Source init, and verification section - orta
* Adds a `danger systems ci_docs` command that outputs the CI sources and their docs - orta
* Merges some of the work on splitting the request source done in #299 - orta, who merged k0nserv's work.
* Add `git.diff_for_file("some/file.txt")` to get a Git::Diff::DiffFile - dbgrandi
* Improves the default file resolves for all the `danger plugins` commands, it will now work with a new plugin by default. - orta
* \n now works in HTML tables - marcelofabri
* You can now pass `full_path: false` to `github.html_link("/path/file.txt", full_path: false)` to have it only show the filename. - orta
* `danger plugins readme` shows attributes correctly. - orta

## 2.0.1

* Updates the `danger init` template to 2.0 syntax - orta

## 2.0.0

* **BREAKING** Removes a lot of top-level attributes in the DSL, moving them into scoped plugins - orta

Full list of changes:

```
# Git Stuff
modified_files -> git.modified_files
added_files -> git.added_files
deleted_files -> git.deleted_files
lines_of_code -> git.lines_of_code
deletions -> git.deletions
insertions -> git.insertions
commits -> git.commits

# GitHub Stuff
pr_title ->  github.pr_title
pr_body -> github.pr_body
pr_author -> github.pr_author
pr_labels -> github.pr_labels
branch_for_base -> github.branch_for_base
branch_for_head -> github.branch_for_head
base_commit -> github.base_commit
head_commit -> github.head_commit
env.request_source.pr_json -> github.pr_json
env.request_source.api -> github.api

# Importing Stuff
import -> plugin.import
```

The main reason for this is that we can support many code review APIs without having to fudge the Dangerfile DSL to make them conform to GitHub standards. This would mean a gitlab user could write `gitlab.mr_author` to access the author once [#229](https://github.com/danger/danger/pull/299) lands.

It also ensures that Danger's plugins are treated like external plugins. This means any work going into improving core plugins (via documentation or automation for example) will improve the upcoming plugin community.

I don't like breaking backwards compatibility. Sorry, for as far as I can see at this point, this is the only one Danger needs.
* add `pr_diff` exposing the unified diff for the PR to the GitHub plugin - champo
* Improvements to the linter and the JSON output for plugin docs - orta
* Add `html_link` to the GitHub plugin - marcelofabri
I don't like breaking backwards comparability. Sorry, for as far as I can see at this point, this is the only one Danger needs.
* add `pr_diff` exposing the unified diff for the PR to the Github plugin - champo
* Improvements to the linter, readme generator and the JSON output for plugin docs - orta

## 0.10.1

* Add `danger local --pry`, which drops into a Pry shell after eval-ing the Dangerfile - dbgrandi

## 0.10.0

* Improves wording when failing a OSS build - orta
* Add support for org-wide Dangerfile -- KrauseFx
  - To use this, create a repo on your GitHub organization called "danger" (or "Danger")
  - Add a `Dangerfile` to the root of that repo.
  - This new `Dangerfile` is ran after current repo's `Dangerfile`.

  The org `Dangerfile` will have access to all of the same plugins, and metadata.
  For an example, see: https://github.com/Themoji/danger

* Breaking: `import_url` does not append `.rb` to your url anymore. - KrauseFx
* Minor core documentation updates - orta
* `danger plugin lint` now says it's failed when it's failed, not when it succeeds - orta
* Fixes to the markdown support in `warn`, `fail` and `message` - orta
* Add http caching for Github API calls when running `danger local` - dbgrandi

## 0.9.1

* Danger no longer relies on the GNU utilities and can run on Windows - henriwatson
* `danger plugins lint` is a linter - orta
* `danger plugins json` will show you the JSON output of your docs - orta

## 0.9.0

* `danger plugin` is removed in favor of `danger plugins` - dbgrandi/orta
  - `danger plugin lint` is now `danger plugins lint`
  - `danger plugin readme` is now `danger plugins readme`
* use `claide-plugins` gem to provide plugin management - dbgrandi
  - extends `claide-plugins` gem with list, search, create commands
  - `list` is the default command for `danger plugins`
  - `list` shows all plugins
  - `search` let's you search with a regexp
  - `create` uses https://github.com/danger/danger-plugin-template to bootstrap a new danger plugin

* Warn users not to store GitHub tokens in the repository -- dantoml
* Crash on load fix for `danger plugins readme` -- orta
* Add support for Surf CI (https://github.com/surf-build/surf) -- paulcbetts
* `danger plugins lint` contains more information - orta
* Make link instructions in onboarding OS aware -- K0nserv

## 0.8.5

* Converts the message link to be http://danger.systems - orta
* Fix `danger lib lint` with no params not finding the plugin paths - orta
* Converts `""` usage to `''` where possible -- dantoml
* More documentation params are exposed to the linter - orta
* Documentation audit - orta
* Use proper commits for calculating diff.
* Update environment variables used by Buildkite - bentrengrove

## 0.8.4

* Initial work on `danger plugin lint` command - orta
* `danger plugin lint` can run with either:
  - a list of file paths
  - a list of gems
  - no arguments, which will parse `lib/**/**/*` to lint your local plugins
* Moved new plugin to `danger plugin new` - orta
* Added `api` to the DSL, which is a shortcut to the active `Octokit::Client` - orta
* Renamed `branch_for_merge` to `branch_for_base` and also added `branch_for_head` - orta
* Initial work on namespacing existing plugins - orta
* Notify the user to add the new GitHub account as collaborator to Close Source project
* Fixes a problem running `danger local` due to a missing dependency on yard - ashfurrow
* Improvements for CircleCI CI detection - orta


## 0.8.3

* Fix updating of the commit status after danger check. - justMaku
* Relies on the current git HEAD, instead of pulling a merge branch from GitHub - justMaku
* Use Cork for console output. - DanToml
* Print a list of results, instead of a table. - DanToml

## 0.8.2

* Support multiple Danger instances with `--dangerId` - marcelofabri
* Add base request source so services other than GitHub could be used with Danger. - justMaku
* Don't validate CI sources that don't expose all required environment variables.  - justMaku
* Add support for TeamCity CI - rbuussyghin

## 0.8.1

* Fix Ruby 2.0 support - segiddins

## 0.8.0

* Considerable under-the-hood changes around the DSL, shouldn't affect end-user Dangerfiles though - orta
* Fix for `danger local` crash due to ^ - dbgrandi
* Add support for Drone CI - gabro
* [BREAKING] Add initial support for more expressive and documented plugins. Breaks all existing plugins. - dbgrandi/orta
* All core DSL attributes are handled via Danger Plugins - orta
* Initial work on the Plugin -> JSON mapper - orta
* Add support for Semaphore CI - starsirius
* Add Ruby 2.3 support - segiddins
* Allow Dangerfile path to be configured - gabro

## 0.7.4

* Adds the ability to specify a PR number in `danger local` - orta
* Ensures local branches are set up with  `danger local` - orta
* Add `commits` for the Git SCM source - segiddins

## 0.7.3

* Minor `danger init` typo fixes - orta + danger
* Added support for CLAide-based plugins - segiddins

## 0.7.2

* Auto follow of remote plugin URL redirects - KrauseFx
* Adding XcodeServer provider - antondomashnev

## 0.7.1

* Hotfix: import of plugins didn't work depending on alphabetical order - KrauseFx

## 0.7.0

* Added support for local plugins - KrauseFx
* Added support for remote plugins - KrauseFx
* Added new `danger new_plugin` command to create plugins in the fastlane - KrauseFx
* Added printing of table summaries after running danger - KrauseFx
* Refactored all plugins to be classes instead of methods - KrauseFx
* Added auto-import of local plugins - KrauseFx
* Resolved issues are now crossed out by Danger - marcelofabri
* Added new `markdown` command to Danger DSL - KrauseFx
* Added new `modified_files.include?("rakelib/*_stats.rake")` file globbing support - KrauseFx

## 0.6.5

* Enterprise GitHub support - dbgrandi
* Use branches for comparison, not commits - orta
* Breaking: DSL change `files_*` to `*_files` for readability - jeroenvisser101

## 0.6.0

* Added internal plugin system - KrauseFx
* Refactored unit tests - KrauseFx
* Fixed issue when PR Title or PR body is nil - KrauseFx
* Added support for `git://`-prefixed url as remote - jeroenvisser101
* Added comment based violation suppression - marcelofabri

## 0.5.2

* Typo fixes for `danger init` - lumaxis

## 0.5.1

* Fixes for `danger init` - krausefx

## 0.5.0

* New: Converted `danger init` into a wizard for setting up Danger, walking you though tokens/ci - orta
* Breaking: `files_removed` to `files_deleted` ( to be more consistent with git's terminology. ) - orta

* Revised underlying git tooling for generating file/diff metadata - orta
* re-revise underlying git tooling to not use something based on libgit2 - orta
* Set CHANGELOG merge strategy to union - marcelofabri
* Remove `nap` dependency - marcelofabri
* Show command summary in help - marcelofabri
* Use 100% width tables for messages - marcelofabri

## 0.3.0

* Adding Jenkins provider - marcelofabri
* Add a `danger local` command to test your current Dangerfile against the last PR merged on the repo - orta
* Calling CircleCI API when `CI_PULL_REQUEST` is not set - marcelofabri
* Look inside PR JSON for the commit range (instead of getting from CI providers) - marcelofabri
* Adds `pr_labels` to DSL - marcelofabri
* Makes the CircleCI provider validate, but not run on non-PR builds - orta
* Take the git before...after references out of ENV vars from CI providers - orta
* Fixes CircleCI when dealing with URLs like `https://github.com/artsy/eigen/compare/b0f6a2a9ff6f%5E...316b694875c8` - orta
* Ensure all comments are downloaded, previously it was capped at 30 - orta
* Attach commit metadata to the message invisibly - orta
* On danger/danger we now fail if there's no changelog entry - orta
* Moved to an org [feb 9]
* Adds support for Circle CI on danger/danger

## 0.2.1

* Edits an existing ticket rather than making a new one - orta

## 0.2

* Support making comments on a GitHub PR - Felix
* Use GitHub status API to provide extra info on a PR - Felix
* DRY the HTML comment - orta
* Don't show a message if there are not warnings/errors - orta

## 0.1

* Parses a `Dangerfile` - orta
* Gets GitHub details from Travis & CircleCI - orta
* Gets PR details from GitHub - orta
* Gets Git details from local Git - orta
* Fails when you say it's failed in  the  Dangerfile - orta
