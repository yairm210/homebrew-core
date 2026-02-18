class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "7683b958d19557462af93eb27a1ddb53bfd7579e3ab5b51e59e0db4ec6f28b76"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26075ede58140d586ae0d4eea412f0e53d2cfe21bf14cecf1cf412fbe67f18da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "273f98ba43939e1fc58ec91ef4d3fdd5d51fc6554cc1062f6c1f0ac4487192b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05797564afc3d4bfb211a50dfd6d594b4bf268678646cea85ecc65d04e51b851"
    sha256 cellar: :any_skip_relocation, sonoma:        "d01a06635a609cebb9ee3f5c02507cff4dbcea722ffd1759b8402c773edf801c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d658fd8886f601d1234a5f523449be9d039882e994eec45d497e40d42b556771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d224238682b0296784ff1e697eeaaa3aa2e1c16b74141666bcf1f55f34de4b6c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kwctl")

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwctl --version")

    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
