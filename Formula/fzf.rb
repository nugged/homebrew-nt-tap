 class Fzf < Formula
   desc "Command-line fuzzy finder"
   homepage "https://github.com/nugged/fzf"
   url "https://github.com/nugged/fzf.git",
       using:    :git,
       branch:   "fix-nil-pointer-dereference-crash"
   version "0.63.0-fix"
   license "MIT"

   depends_on "go" => :build

   def install
     # Build the binary with version and revision info
     system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")

     # Install binaries and helper scripts
     man1.install "man/man1/fzf.1",    "man/man1/fzf-tmux.1"
     bin.install "bin/fzf-tmux"
     bin.install "bin/fzf-preview.sh"

     # Shell integration scripts (install/uninstall, key-bindings, completions)
     prefix.install "install", "uninstall"
     (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
     (prefix/"shell").install %w[bash zsh].map        { |s| "shell/completion.#{s}" }
     (prefix/"plugin").install "plugin/fzf.vim"
   end

   def caveats
     <<~EOS
       To set up shell integration, see:
         https://github.com/junegunn/fzf#setting-up-shell-integration
       To use fzf in Vim, add the following line to your .vimrc:
         set rtp+=#{opt_prefix}
     EOS
   end

   test do
     assert_match "fzf", shell_output("#{bin}/fzf --version")
   end
   test do
     (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
     output = pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
     assert_equal "world", output
   end
 end
