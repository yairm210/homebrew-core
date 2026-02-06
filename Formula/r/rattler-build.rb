class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://rattler.build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "a66c2ddddda9ad57240f5b01b1a3ee71b762400ea3c1b2ec462ee103a130d5be"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa5f40a671596b96a067eb0fd2a82664648fb848661f5427cc18637c555aca38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d227ea7abc07e569bdd128e65364b48f9a6b4fe32c306ed0014964593278a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918a7cd77d3dafc9bd689cd3d73dc78b36ec4c45c5459a711b8b210bdf483a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "b56dbac9faf407ce0bcb6789700523696971fb4567da781dc884e9335196577f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50cb2aefed73d47cfeb5dda1829236606626aedf0b3699874dbb3d6dcf731517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4993c6d38eec87926dcc1b4da285db1941519b75b4e16bd39979b08c12b90ba8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe/recipe.yaml").write <<~YAML
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    YAML
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_path_exists testpath/"output/noarch/test-package-0.1.0-buildstring.conda"

    assert_match version.to_s, shell_output("#{bin}/rattler-build --version")
  end
end
