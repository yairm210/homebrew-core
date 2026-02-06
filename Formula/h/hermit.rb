class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "9d7876183a5d5d5c0eefda566d8212eacdf5238fee9375cc4625a2b75aa76ca6"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82f897986bbe28ab047828d1b4e2aeff88ae6153741c5af81c6b226f3231fc4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f2a044d11ad2d9b7bdb5526920b5cbb8a4e5d4c6f7a64c71722482efcd5b419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c3e85e21c8e2d56219315cd6795c07d95203fa90ee6db4d1b6e8e645a27bf52"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4f25c6e883d7efca3d19127237f9c9d85292f74956da3a336224d48fd7a1b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be41cd54e0e6819b1d29df3c2fb0ea5de7f50300df2e100c6c178b785b1bc2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f578210833b76e5d836c11d9ae32d72b6263f7f7f3ab1cebe4afed8e043e9b"
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
