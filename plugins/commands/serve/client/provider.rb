require "google/protobuf/well_known_types"

module VagrantPlugins
  module CommandServe
    class Client
      class Provider < Client
        include CapabilityPlatform

        # Generate callback and spec for required arguments
        #
        # @return [SDK::FuncSpec, Proc]
        def usable_func
          spec = client.usable_spec(Empty.new)
          cb = proc do |args|
            client.usable(args).is_usable
          end
          [spec, cb]
        end

        # @return [Boolean] is the provider usable
        def usable?
          run_func
        end

        # Generate callback and spec for required arguments
        #
        # @return [SDK::FuncSpec, Proc]
        def installed_func
          spec = client.installed_spec(Empty.new)
          cb = proc do |args|
            client.installed(args).is_installed
          end
          [spec, cb]
        end

        # @return [Boolean] is the provider installed
        def installed?
          run_func
        end

        # Generate callback and spec for required arguments
        #
        # @param name [String, Symbol] name of action
        # @return [SDK::FuncSpec, Proc]
        def action_func(name)
          name = name.to_s
          spec = client.action_spec(
            SDK::Provider::ActionRequest.new(
              name: name
            )
          )
          cb = proc do |args|
            client.action(
              SDK::Provider::ActionRequest.new(
                name: name,
                func_args: args,
              )
            )
          end
          [spec, cb]
        end

        # @param [Sdk::Args::Machine]
        # @param [Symbol] name of the action to run
        def action(machine, name)
          run_func(Type::Direct.new(value: [machine]), func_args: name)
        end

        # Generate callback and spec for required arguments
        #
        # @return [SDK::FuncSpec, Proc]
        def machine_id_changed_func
          spec = client.machine_id_changed_spec(Empty.new)
          cb = proc do |args|
            client.machine_id_changed(args)
          end
          [spec, cb]
        end

        # @param [Sdk::Args::Machine]
        def machine_id_changed(machine)
          run_func(machine)
        end

        # Generate callback and spec for required arguments
        #
        # @return [SDK::FuncSpec, Proc]
        def ssh_info_func
          spec = client.ssh_info_spec(Empty.new)
          cb = proc do |args|
            Vagrant::Util::HashWithIndifferentAccess.new(
              client.ssh_info(args).to_h
            )
          end
          [spec, cb]
        end

        # @param [Sdk::Args::Machine]
        # @return [Hash] ssh info for machine
        def ssh_info(machine)
          run_func(machine)
        end

        # Generate callback and spec for required arguments
        #
        # @return [SDK::FuncSpec, Proc]
        def state_func
          spec = client.state_spec(Empty.new)
          cb = proc do |args|
            mapper.map(client.state(args), to: Vagrant::MachineState)
          end
          [spec, cb]
        end

        # @param [Sdk::Args::Machine]
        # @return [Vagrant::MachineState] machine state
        def state(machine)
          run_func(machine)
        end
      end
    end
  end
end