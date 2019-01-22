#
# Cookbook:: syslog_ng
# Spec:: install_helpers_spec
#
# Copyright:: 2018, Ben Hughes <bmhughes@bmhughes.co.uk>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'SyslogNg::InstallHelpers' do
  let(:dummy_class) { Class.new { include SyslogNg::InstallHelpers } }
  describe '.installed_version_get' do
    context('when called') do
      let(:shellout) do
        double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0, live_stream: '')
      end

      it 'return syslog-ng version as a float' do
        allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
        allow(shellout).to receive(:error!).and_return(nil)
        allow(shellout).to receive(:stdout).and_return('3.18\n1')

        expect(dummy_class.new.installed_version_get).to be_a(Float)
        expect(dummy_class.new.installed_version_get).to eq(3.18)
      end
    end
  end

  describe '.repo_get_packages' do
    platforms = {
      'rhel' => "syslog-ng-debuginfo\nsyslog-ng-devel\nsyslog-ng-geoip\nsyslog-ng-http\nsyslog-ng-java\nsyslog-ng-java-deps\nsyslog-ng-json\nsyslog-ng-libdbi\nsyslog-ng-mongodb\nsyslog-ng-python\nsyslog-ng-redis\nsyslog-ng-riemann\nsyslog-ng-smtp\nsyslog-ng\n",
      'fedora' => "syslog-ng\nsyslog-ng-http\nsyslog-ng-smtp\nsyslog-ng-http\nsyslog-ng-smtp\nsyslog-ng-amqp\nsyslog-ng-geoip\nsyslog-ng-redis\nsyslog-ng-geoip\nsyslog-ng-redis\nsyslog-ng-libdbi\nsyslog-ng-devel\nsyslog-ng-riemann\nsyslog-ng-devel\nsyslog-ng-riemann\nsyslog-ng-devel\nsyslog-ng-mongodb\nsyslog-ng-java\nsyslog-ng-python\nsyslog-ng-debugsource\nsyslog-ng-python\nsyslog-ng-java-deps\nsyslog-ng-debuginfo\nsyslog-ng-http-debuginfo\nsyslog-ng-java-debuginfo\nsyslog-ng-smtp-debuginfo\nsyslog-ng-geoip-debuginfo\nsyslog-ng-redis-debuginfo\nsyslog-ng-libdbi-debuginfo\nsyslog-ng-python-debuginfo\nsyslog-ng-riemann-debuginfo\n",
      'debian' => "syslog-ng\nsyslog-ng-core\nsyslog-ng-dbg\nsyslog-ng-dev\nsyslog-ng-mod-add-contextual-data\nsyslog-ng-mod-amqp\nsyslog-ng-mod-geoip\nsyslog-ng-mod-graphite\nsyslog-ng-mod-journal\nsyslog-ng-mod-json\nsyslog-ng-mod-mongodb\nsyslog-ng-mod-python\nsyslog-ng-mod-redis\nsyslog-ng-mod-riemann\nsyslog-ng-mod-smtp\nsyslog-ng-mod-sql\nsyslog-ng-mod-stomp\nsyslog-ng-mod-basicfuncs-plus\nsyslog-ng-mod-date\nsyslog-ng-mod-grok\nsyslog-ng-mod-kafka\nsyslog-ng-mod-lua\nsyslog-ng-mod-perl\nsyslog-ng-mod-rss\nsyslog-ng-mod-trigger\nsyslog-ng-mod-zmq\n",
    }

    platforms.each do |platform, packages|
      context("when called with #{platform} platform") do
        let(:shellout) do
          double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0, live_stream: '')
        end

        it "return syslog-ng packages for #{platform}" do
          allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
          allow(shellout).to receive(:error!).and_return(nil)
          allow(shellout).to receive(:stdout).and_return(packages)

          expect(dummy_class.new.repo_get_packages(platform: platform)).to be_a(Array)
          expect(dummy_class.new.repo_get_packages(platform: platform)).to eq(packages.split(/\n+/))
        end
      end
    end

    platforms.delete('debian')
    platforms.each do |platform, packages|
      context("when called with #{platform} platform for COPR") do
        let(:shellout) do
          double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0, live_stream: '')
        end

        it "return syslog-ng packages for #{platform}" do
          allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
          allow(shellout).to receive(:error!).and_return(nil)
          allow(shellout).to receive(:stdout).and_return(packages)

          expect(dummy_class.new.repo_get_packages(platform: platform, copr: true)).to be_a(Array)
          expect(dummy_class.new.repo_get_packages(platform: platform, copr: true)).to eq(packages.split(/\n+/))
        end
      end
    end

    context('when given unknown platform') do
      let(:dummy_class) { Class.new { include SyslogNg::InstallHelpers } }
      it 'raises RuntimeError' do
        expect { dummy_class.new.repo_get_packages(platform: 'unknown') }.to raise_exception(RuntimeError)
      end
    end
  end

  describe '.installed_get_packages' do
    platforms = {
      'rhel' => "syslog-ng-debuginfo\nsyslog-ng-devel\nsyslog-ng-geoip\nsyslog-ng-http\nsyslog-ng-java\nsyslog-ng-java-deps\nsyslog-ng-json\nsyslog-ng-libdbi\nsyslog-ng-mongodb\nsyslog-ng-python\nsyslog-ng-redis\nsyslog-ng-riemann\nsyslog-ng-smtp\nsyslog-ng\n",
      'fedora' => "syslog-ng\nsyslog-ng-http\nsyslog-ng-smtp\nsyslog-ng-http\nsyslog-ng-smtp\nsyslog-ng-amqp\nsyslog-ng-geoip\nsyslog-ng-redis\nsyslog-ng-geoip\nsyslog-ng-redis\nsyslog-ng-libdbi\nsyslog-ng-devel\nsyslog-ng-riemann\nsyslog-ng-devel\nsyslog-ng-riemann\nsyslog-ng-devel\nsyslog-ng-mongodb\nsyslog-ng-java\nsyslog-ng-python\nsyslog-ng-debugsource\nsyslog-ng-python\nsyslog-ng-java-deps\nsyslog-ng-debuginfo\nsyslog-ng-http-debuginfo\nsyslog-ng-java-debuginfo\nsyslog-ng-smtp-debuginfo\nsyslog-ng-geoip-debuginfo\nsyslog-ng-redis-debuginfo\nsyslog-ng-libdbi-debuginfo\nsyslog-ng-python-debuginfo\nsyslog-ng-riemann-debuginfo\n",
      'debian' => "syslog-ng\nsyslog-ng-core\nsyslog-ng-dbg\nsyslog-ng-dev\nsyslog-ng-mod-add-contextual-data\nsyslog-ng-mod-amqp\nsyslog-ng-mod-geoip\nsyslog-ng-mod-graphite\nsyslog-ng-mod-journal\nsyslog-ng-mod-json\nsyslog-ng-mod-mongodb\nsyslog-ng-mod-python\nsyslog-ng-mod-redis\nsyslog-ng-mod-riemann\nsyslog-ng-mod-smtp\nsyslog-ng-mod-sql\nsyslog-ng-mod-stomp\nsyslog-ng-mod-basicfuncs-plus\nsyslog-ng-mod-date\nsyslog-ng-mod-grok\nsyslog-ng-mod-kafka\nsyslog-ng-mod-lua\nsyslog-ng-mod-perl\nsyslog-ng-mod-rss\nsyslog-ng-mod-trigger\nsyslog-ng-mod-zmq\n",
    }

    platforms.each do |platform, packages|
      context("when called with #{platform} platform") do
        let(:shellout) do
          double(run_command: nil, error!: nil, stdout: '', stderr: '', exitstatus: 0, live_stream: '')
        end

        it "return syslog-ng packages for #{platform}" do
          allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
          allow(shellout).to receive(:error!).and_return(nil)
          allow(shellout).to receive(:stdout).and_return(packages)

          expect(dummy_class.new.installed_get_packages(platform: platform)).to be_a(Array)
          expect(dummy_class.new.installed_get_packages(platform: platform)).to eq(packages.split(/\n+/))
        end
      end
    end

    context('when given unknown platform') do
      let(:dummy_class) { Class.new { include SyslogNg::InstallHelpers } }
      it 'raises RuntimeError' do
        expect { dummy_class.new.installed_get_packages(platform: 'unknown') }.to raise_exception(RuntimeError)
      end
    end
  end
end
