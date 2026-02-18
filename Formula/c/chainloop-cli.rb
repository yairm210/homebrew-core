class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.77.2.tar.gz"
  sha256 "6972f663360ab2824dfe67eecc91e94bd9c43e1c5daf4ef2e16238f455b16c4e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a3b102c6ff80ff53a55e2b27f4d3ce250fcd51be393636fb643b2a79fe06367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80befa44c4eb3a0c5cbe5b2023ea514fb1a6d0c08fc85f2efcb53a03efba7d41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8283b8a330fffc838be3ebb507c31e9133a01e786ba8b0bfd0fa7287e571b33f"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a0a819f393ca464b6a0ee8634faa54d6d5a5356606b0334902eb7cb0dca3d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb1393d939216d31ecfb725169d1483f6604b71b06fa88da275b1022edccc44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda4a9e2a7291dabd3e9f654afb14242e6fa36c6bda5973c67e73ee80c2b5a9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
