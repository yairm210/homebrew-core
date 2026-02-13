class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.9.0",
      revision: "78f8afc82cca351ff1bf4fb28a31980c5a4f056d"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc7ec8dbeca8a75d7b476d7e1684eadbbb414b2e144d1eed54897dcb82a3f42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eed23e7893962dc55436f9f579ed1a110d4eade031a59adffe1dedfd35181ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef4581fd8456a9fd896be7d570a5bb53aa952741b1f59e5c10867fb55b28299"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e8afca66c3c9a02acf61f659d8339d525820fd654d8eb13e71ce7513d1b02c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cbf891b5f8b79ea7993eecdc6e309b9d7a3dfbca9f833789594b07f9d679056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fd098a7e4a1ef71226f62af24885974b94ccbf87f12e1b7e63b7cd04cefafa"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
