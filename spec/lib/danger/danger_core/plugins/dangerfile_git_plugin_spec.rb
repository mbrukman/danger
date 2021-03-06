require "ostruct"

def run_in_repo_with_diff
  Dir.mktmpdir do |dir|
    Dir.chdir dir do
      `git init`
      File.open(dir + "/file1", "w") { |f| f.write "More buritto please." }
      `git add .`
      `git commit -m "adding file1"`
      `git checkout -b new-branch`
      File.open(dir + "/file2", "w") { |f| f.write "Pants!" }
      `git add .`
      `git commit -m "adding file2"`
      g = Git.open(".")
      yield g
    end
  end
end

module Danger
  describe DangerfileGitPlugin, host: :github do
    it "fails init if the dangerfile's request source is not a GitRepo" do
      dm = testing_dangerfile
      dm.env.scm = []
      expect { DangerfileGitPlugin.new dm }.to raise_error RuntimeError
    end

    describe "dsl" do
      before do
        dm = testing_dangerfile
        @dsl = DangerfileGitPlugin.new dm
        @repo = dm.env.scm
      end

      it "gets added_files " do
        diff = [OpenStruct.new(type: "new", path: "added")]
        allow(@repo).to receive(:diff).and_return(diff)

        expect(@dsl.added_files).to eq(["added"])
      end

      it "gets deleted_files " do
        diff = [OpenStruct.new(type: "deleted", path: "deleted")]
        allow(@repo).to receive(:diff).and_return(diff)

        expect(@dsl.deleted_files).to eq(["deleted"])
      end

      it "gets modified_files " do
        stats = { files: { "my/path/file_name" => "thing" } }
        diff = OpenStruct.new(stats: stats)
        allow(@repo).to receive(:diff).and_return(diff)

        expect(@dsl.modified_files).to eq(["my/path/file_name"])
      end

      it "gets lines_of_code" do
        diff = OpenStruct.new(lines: 2)
        allow(@repo).to receive(:diff).and_return(diff)

        expect(@dsl.lines_of_code).to eq(2)
      end

      it "gets deletions" do
        diff = OpenStruct.new(deletions: 4)
        allow(@repo).to receive(:diff).and_return(diff)

        expect(@dsl.deletions).to eq(4)
      end

      it "gets insertions" do
        diff = OpenStruct.new(insertions: 6)
        allow(@repo).to receive(:diff).and_return(diff)

        expect(@dsl.insertions).to eq(6)
      end

      it "gets commits" do
        log = ["hi"]
        allow(@repo).to receive(:log).and_return(log)

        expect(@dsl.commits).to eq(log)
      end

      describe "getting diff for a specific file" do
        it "returns nil when a specific diff does not exist" do
          run_in_repo_with_diff do |git|
            diff = git.diff("master")
            allow(@repo).to receive(:diff).and_return(diff)
            expect(@dsl.diff_for_file("file_nope_no_way")).to be_nil
          end
        end

        it "gets a specific diff" do
          run_in_repo_with_diff do |git|
            diff = git.diff("master")
            allow(@repo).to receive(:diff).and_return(diff)
            expect(@dsl.diff_for_file("file2")).to_not be_nil
          end
        end
      end
    end
  end
end
