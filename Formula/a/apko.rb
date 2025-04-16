class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "cdb7ab42a2bcbbd2a840258bf525d6590172d2b393029fd93011ee5a727c6af2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fe13dd7456a7dfdb836c3c73ec686122c0dec816c1697e904f06be3f5663d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe13dd7456a7dfdb836c3c73ec686122c0dec816c1697e904f06be3f5663d58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fe13dd7456a7dfdb836c3c73ec686122c0dec816c1697e904f06be3f5663d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "907d405004cee3bc0ac175f6494744c2fd067da4919e6b5cc96b06ab2467e86e"
    sha256 cellar: :any_skip_relocation, ventura:       "907d405004cee3bc0ac175f6494744c2fd067da4919e6b5cc96b06ab2467e86e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bdbdd04b80fc472ae24be3f5a79caa4c7d578a7ee70d27e596ae87d51823346"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
