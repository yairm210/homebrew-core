class OpensearchDashboards < Formula
  desc "Open source visualization dashboards for OpenSearch"
  homepage "https://docs.opensearch.org/latest/dashboards/"
  # Build fails if not a git repository
  url "https://github.com/opensearch-project/OpenSearch-Dashboards.git",
      tag:      "3.5.0",
      revision: "7e86cf810d6e616a3453dd93062d7e22fa16c477"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92dd911bf3b2cdbf80fad0f6962b5c4e81a4e5d914c2b5c66a50a282818e10ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88374c70d2e31bc95fb61eefbe4ed41dea31e9b3100673e5bb9df8a593c00386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fe3e0328b09cc8c2aaaebf25a8d537de8215011d4a734d00a8a5aac04c02f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c72e84afece9a7eb093fbedd72ea1c7b67ffd00f5a87532a1ca9853478f45a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e49fb1dcddbf39dad87d408d1196dbac1e88fe5d42bf05c9016092ed684271a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1827491f85dbe9d072cb1578821be0ded5e5940051afa5ca2380e7c554200d"
  end

  depends_on "yarn" => :build
  depends_on "opensearch" => :test
  depends_on "node@22"

  # - Do not download node and discard all actions related to this node
  patch :DATA

  def install
    system "yarn", "osd", "bootstrap"
    system "node", "scripts/build", "--release", "--skip-os-packages", "--skip-archives", "--skip-node-download"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    cd "build/opensearch-dashboards-#{version}-#{os}-#{arch}" do
      inreplace "bin/use_node",
                /NODE=".+"/,
                "NODE=\"#{Formula["node@22"].opt_bin}/node\""

      inreplace "config/opensearch_dashboards.yml",
                /#\s*pid\.file: .+$/,
                "pid.file: #{var}/run/opensearchDashboards.pid"

      (etc/"opensearch-dashboards").install Dir["config/*"]
      rm_r(Dir["{config,data,plugins}"])

      prefix.install Dir["*"]
    end

    (var/"log/opensearch-dashboards").mkpath
    (var/"lib/opensearch-dashboards").mkpath
    (var/"opensearch-dashboards/plugins").mkpath
    prefix.install_symlink var/"lib/opensearch-dashboards" => "data"
    prefix.install_symlink var/"opensearch-dashboards/plugins"
    prefix.install_symlink etc/"opensearch-dashboards" => "config"
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch-dashboards/
      Logs:    #{var}/log/opensearch-dashboards/opensearch-dashboards.log
      Plugins: #{var}/opensearch-dashboards/plugins/
      Config:  #{etc}/opensearch-dashboards/
    EOS
  end

  service do
    run opt_bin/"opensearch-dashboards"
    log_path var/"log/opensearch-dashboards.log"
    error_log_path var/"log/opensearch-dashboards.log"
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"

    os_port = free_port
    (testpath/"data").mkdir
    (testpath/"logs").mkdir
    os_pid = spawn Formula["opensearch"].bin/"opensearch", "-Ehttp.port=#{os_port}",
                                                           "-Epath.data=#{testpath}/data",
                                                           "-Epath.logs=#{testpath}/logs"

    (testpath/"config.yml").write <<~YAML
      server.host: "127.0.0.1"
      path.data: #{testpath}/data
      opensearch.hosts: ["http://127.0.0.1:#{os_port}"]
    YAML

    osd_port = free_port
    osd_pid = spawn bin/"opensearch-dashboards", "-p", osd_port.to_s, "-c", testpath/"config.yml"

    output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--location", "--silent", "127.0.0.1:#{osd_port}")
      break if output.present? && output != "OpenSearch Dashboards server is not ready yet"
    end

    assert_includes output, "<title>OpenSearch Dashboards</title>"
  ensure
    Process.kill("TERM", osd_pid)
    Process.wait(osd_pid)
    Process.kill("TERM", os_pid)
    Process.wait(os_pid)
  end
end

__END__
diff --git a/src/dev/build/build_distributables.ts b/src/dev/build/build_distributables.ts
index d764c5df28..e37b71e04a 100644
--- a/src/dev/build/build_distributables.ts
+++ b/src/dev/build/build_distributables.ts
@@ -63,8 +63,6 @@ export async function buildDistributables(log: ToolingLog, options: BuildOptions
    */
   await run(Tasks.VerifyEnv);
   await run(Tasks.Clean);
-  await run(options.downloadFreshNode ? Tasks.DownloadNodeBuilds : Tasks.VerifyExistingNodeBuilds);
-  await run(Tasks.ExtractNodeBuilds);

   /**
    * run platform-generic build tasks
diff --git a/src/dev/build/tasks/create_archives_sources_task.ts b/src/dev/build/tasks/create_archives_sources_task.ts
index 5ba01ad129..b4ecbb0d3d 100644
--- a/src/dev/build/tasks/create_archives_sources_task.ts
+++ b/src/dev/build/tasks/create_archives_sources_task.ts
@@ -41,38 +41,6 @@ export const CreateArchivesSources: Task = {
           source: build.resolvePath(),
           destination: build.resolvePathForPlatform(platform),
         });
-
-        log.debug(
-          'Generic build source copied into',
-          platform.getNodeArch(),
-          'specific build directory'
-        );
-
-        // copy node.js install
-        await scanCopy({
-          source: (await getNodeDownloadInfo(config, platform)).extractDir,
-          destination: build.resolvePathForPlatform(platform, 'node'),
-        });
-
-        // ToDo [NODE14]: Remove this Node.js 14 fallback download
-        // Copy the Node.js 14 binaries into node/fallback to be used by `use_node`
-        if (platform.getBuildName() === 'darwin-arm64') {
-          log.warning(`There are no fallback Node.js versions released for darwin-arm64.`);
-        } else {
-          await scanCopy({
-            source: (
-              await getNodeVersionDownloadInfo(
-                NODE14_FALLBACK_VERSION,
-                platform.getNodeArch(),
-                platform.isWindows(),
-                config.resolveFromRepo()
-              )
-            ).extractDir,
-            destination: build.resolvePathForPlatform(platform, 'node', 'fallback'),
-          });
-        }
-
-        log.debug('Node.js copied into', platform.getNodeArch(), 'specific build directory');
       })
     );
   },
diff --git a/src/dev/notice/generate_build_notice_text.js b/src/dev/notice/generate_build_notice_text.js
index b32e200915..2aab53f3ea 100644
--- a/src/dev/notice/generate_build_notice_text.js
+++ b/src/dev/notice/generate_build_notice_text.js
@@ -48,7 +48,7 @@ export async function generateBuildNoticeText(options = {}) {

   const packageNotices = await Promise.all(packages.map(generatePackageNoticeText));

-  return [noticeFromSource, ...packageNotices, generateNodeNoticeText(nodeDir, nodeVersion)].join(
+  return [noticeFromSource, ...packageNotices, ''].join(
     '\n---\n'
   );
 }
