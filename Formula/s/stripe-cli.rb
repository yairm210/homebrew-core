class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.9.tar.gz"
  sha256 "f8c8dbed9b929a9c9bda93c673616722b281d80037d56e80e3a5925f257697ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "962f99dd5aca9dc2333b2cd9b800a06c0990364fc4866ca28f00157c4c397418"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "962f99dd5aca9dc2333b2cd9b800a06c0990364fc4866ca28f00157c4c397418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "962f99dd5aca9dc2333b2cd9b800a06c0990364fc4866ca28f00157c4c397418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17591d05593ce13037db7a5e67e50d2552d54aab172236f793ebd3b822916d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b9ce132841a79fdb3b81b0160f69e63a1c58eee6f6adaade916f4f77acfae9b"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end
