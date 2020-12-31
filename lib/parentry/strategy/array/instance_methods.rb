module Parentry
  module Strategy
    module Array
      module InstanceMethods
        def parse_parentry(input = parentry)
          input
        end

        def compute_parentry
          return [] unless persisted?

          parent.present? ? parent.parentry + [id] : [id]
        end

        def cascade_parentry
          old_path, new_path = saved_changes[parentry_column]
          parentry_scope.where(
            ["#{parentry_column} @> ARRAY[:tree] AND id != :id", { tree: old_path, id: id }]
          ).update_all(
            [
              "#{parentry_column} = array_cat(ARRAY[?], #{parentry_column}[?:array_length(#{parentry_column}, 1)])",
              new_path, old_path.size + 1
            ]
          )
        end

        def subtree_conditions
          ["#{parentry_column} @> ARRAY[?]", parentry]
        end

        def ancestor_conditions
          ["#{parentry_column} <@ ARRAY[?]", parentry]
        end
      end
    end
  end
end
