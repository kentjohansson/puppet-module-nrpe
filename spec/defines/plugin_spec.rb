require 'spec_helper'

describe 'nrpe::plugin' do
  context 'should create plugin file with all options specified' do
    let(:title) { 'check_root_partition' }
    let(:params) do
      { :plugin     => 'check_disk',
        :libexecdir => '/usr/lib64/nagios/plugins',
        :args       => '-w 20% -c 10% -p /',
      }
    end
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should include_class('nrpe') }

    it {
      should contain_file('nrpe_plugin_check_root_partition').with({
        'ensure'  => 'file',
        'path'    => '/etc/nrpe.d/check_root_partition.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
      })
    }

    it {
      should contain_file('nrpe_plugin_check_root_partition') \
        .with_content(/^command\[check_root_partition\]=\/usr\/lib64\/nagios\/plugins\/check_disk -w 20% -c 10% -p \/$/)
    }
  end

  context 'should create plugin file with only args param specified' do
    let(:title) { 'check_load' }
    let(:params) { { :args => '-w 10,8,8 -c 12,10,9' } }
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it { should include_class('nrpe') }

    it {
      should contain_file('nrpe_plugin_check_load').with({
        'ensure'  => 'file',
        'path'    => '/etc/nrpe.d/check_load.cfg',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'require' => 'File[nrpe_config_dot_d]',
      })
    }

    it {
      should contain_file('nrpe_plugin_check_load') \
        .with_content(/^command\[check_load\]=\/usr\/lib\/nagios\/plugins\/check_load -w 10,8,8 -c 12,10,9$/)
    }
  end

  context 'with libexecdir set to a non absolute path' do
    let(:title) { 'check_root_partition' }
    let(:params) do
      { :plugin     => 'check_disk',
        :libexecdir => 'invalid/path',
        :args       => '-w 20% -c 10% -p /',
      }
    end
    let(:facts) do
      { :osfamily          => 'RedHat',
        :lsbmajdistrelease => '6',
      }
    end

    it 'should fail' do
      expect {
        should include_class('nrpe::plugin')
      }.to raise_error(Puppet::Error)
    end
  end
end
