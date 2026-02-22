class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "e81e8ffda86bfb78f6eb1aa1e812264bd3625efc05390c6edba9a42fa7c8ded1"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb6c6366b353cb024ce857e424b876f96ace01ae9ac6ef85fd4a2a60590c83ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e9dd079197419f4d25f14979d70edb36b787e65fe629c134d3538c740797544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7dcb74e026feed7d9fb33a21abfeeac62744da3bd4d1949bd0205d0d5eba9d7"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
