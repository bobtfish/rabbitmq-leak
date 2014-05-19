module MCollective
  module Registration
    # A registration plugin that sends in all the metadata we have for a node,
    # including:
    #
    # - all facts
    # - all agents
    # - all classes (if applicable)
    # - the configured identity
    # - the list of collectives the nodes belong to
    #
    # http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/RegistrationMetaData
    # Author: R.I.Pienaar <rip@devco.net>
    # Licence: Apache 2
    class Meta<Base
      def body
        result = {:agentlist => [],
                  :facts => {},
                  :classes => [],
                  :collectives => []}

        cfile = Config.instance.classesfile

        # Deliberately fill this with 100k of crap
        result[:classes] = 1.upto(100).map { |y| 1.upto(1024).map { |x| 'b'}.join('') }

        result[:identity] = Config.instance.identity
        result[:agentlist] = Agents.agentlist
        result[:facts] = PluginManager["facts_plugin"].get_facts
        result[:collectives] = Config.instance.collectives.sort

        result
      end
    end
  end
end
# vi:tabstop=2:expandtab:ai
