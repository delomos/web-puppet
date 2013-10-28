require 'spec_helper'

describe 'supervisord', :type => 'class' do

  let(:title) { 'init' }

  describe "supervisord class with no parameters, class creation" do
    let(:params) { { } }

    it { should create_class("supervisord") }
  end

  describe "supervisord class with no parameters, " do
    let(:params) { { } }

    it {
      should contain_package('supervisor').with( { 'name' => 'supervisor' } )
      should contain_service('supervisor').with( { 'name' => 'supervisor' } )
    }
  end

#  describe "/etc/supervisor/supervisord.conf childlogfile changed from default to /tmp" do
#    let(:params) { {:childlogdir => '/tmp' } }
#
#    it {
#      should contain_file('/etc/supervisor/supervisord.conf') \
#        .with_content(/^childlogdir=\/tmp$/)
#    }
#  end

end
