class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "f1b007d16562ba9fe657ed17995ab48332062cd54ba3ffcfd070d0022b0ade20"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62a9cf48a0f51dcdaef91efb596e2289f75674aa6a434175224285756ddaea63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "646acf7b7234039a872b0cf08279b7059bfc746b03baa821c94f344a8fc1f765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97cd2754a6f74d51ffcdd535cdad49eb14bcb387f71bd1535dcb184dddc27957"
    sha256 cellar: :any_skip_relocation, sonoma:        "b689fd04524f092f5cb179828112cf29141d1387a6fbb4bb5c09d99b10e4e39b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5ad707ba63d48f933196bb61751118bfa3f2d930a30080310b8b9541c93ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd3fdb83e65936b52b0f523c4d67e76d3116bb53d9a472cde9494d75929c3c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
