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
    # Build a single-arch binary for this machine
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Shell completions
    # bash_completion.install "shell/completion.bash" => "fzf.bash"
    # zsh_completion.install  "shell/completion.zsh"    => "_fzf"
    # fish_completion.install "shell/completion.fish"

    # Manpage
    man1.install "man/man1/fzf.1"
  end

  test do
    assert_match "fzf", shell_output("#{bin}/fzf --version")
  end
end
