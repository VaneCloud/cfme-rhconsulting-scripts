require_relative 'rhconsulting_illegal_chars'
require_relative 'rhconsulting_options'

class MiqUserSeed
    class ParsedNonDialogYamlError < StandardError; end

    def seed
        root = Tenant.roots.first
        raise "示例部门已存在" unless root.children.where(:name => "示例部门").empty?
        dep = root.children.create(name: '示例部门', divisible: true, description: '示例部门')
        dep.save
        project = dep.children.create(name: '示例项目', divisible: false)
        project.save
        user = User.new({:userid => 'user1', :name => '示例用户1', :password => 'user1'})
        user2 = User.new({:userid => 'user2', :name => '示例用户2', :password => 'user2'})
        user1.miq_groups = [project.miq_groups.last]
        user1.save
        user2.miq_groups = [project.miq_groups.last]
        user2.save
        it_admin = User.new({:userid => 'itadmin', :name => '示例IT管理员', :password => 'itadmin'})
        it_admin.miq_groups = [project.miq_groups.first]
        it_admin.save
        project_admin = User.new({:userid => 'projectadmin', :name => '示例部门管理员', :password => 'projectadmin'})
        project_admin.miq_groups = [project.miq_groups[1]]
        project_admin.save
    end
end


namespace :rhconsulting do
  namespace :users do
      task :seed => [:environment] do
          MiqUserSeed.new.seed
      end
  end
 end
