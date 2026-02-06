class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "47959a86c2df41d8c05a7431c631eff38fe00211088a3d93dcb14f897f147ee2"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "640f9b80bf80b98bf3ea86b76b8c3bda224d01cb4d9ded9acb281ff0d2ab2061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59b23cd7fb6c13771fe10a3b461c659b428517d20d47be97fa9fbb0700dca8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8545c2116d3fbb65c22bdc0bb59624bfac99aff7920f644229b0fd74843956"
    sha256 cellar: :any_skip_relocation, sonoma:        "b956bf9dcf4dd4aceac8d39ad1bc79a47f44d25f6cc11af99af4daf7a4c5d73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b407e878eb829d432b0517d678b12cf585d5111e91aea7c96c9b3d86f6ad3709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28fe3d0ef02561e1c7289f40cf0e25b67991902c16146c43e5543d1548f91543"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end
