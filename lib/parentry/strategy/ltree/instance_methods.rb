module Parentry
  module Strategy
    module Ltree
      module InstanceMethods
        def parse_parentry(input = parentry)
          input.to_s.split('.').map(&:to_i)
        end

        def compute_parentry
          parent.present? ? "#{parent.parentry}.#{id}" : id.to_s
        end

        def cascade_parentry
          old_path, new_path = saved_changes[parentry_column]
          parentry_scope.where(
            ["#{parentry_column} <@ :tree AND id != :id", { tree: old_path, id: id }]
          ).update_all(
            [
              "#{parentry_column} = :new_path || subpath(#{parentry_column}, nlevel(:old_path))",
              { new_path: new_path, old_path: old_path }
            ]
          )
        end

        def subtree_conditions
          ["#{parentry_column} <@ ?", parentry]
        end

        def ancestor_conditions
          ["#{parentry_column} @> ?", parentry]
        end
      end
    end
  end
end
