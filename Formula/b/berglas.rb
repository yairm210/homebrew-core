class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "36797ff44e547de7307ed12edb7a4c2e4e25302fbf67c843c2989ae2b986eab1"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56e2b86ce91a7b1b91e80efe7a66ca41e6788b05caf0d7a8b1be023bdb65640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56e2b86ce91a7b1b91e80efe7a66ca41e6788b05caf0d7a8b1be023bdb65640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56e2b86ce91a7b1b91e80efe7a66ca41e6788b05caf0d7a8b1be023bdb65640"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9a040d38de90efb9014a03fd03f5083b754343e0f283ee9174c5d9375796506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f569a591152d1f000e0cbf7525e0ca3d51f3b69ac8b21c25573be814b21b5cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2aa65587a956447c2a37cec97697baf4f0857ae1cd9fda8b3cab5fc345c0ce7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
