class AddTsvIndexingToUser < ActiveRecord::Migration
  def up
    add_column :users, :tsv_data, :tsvector

    ## Adds an index for this new column
    execute <<-SQL
      CREATE INDEX index_users_tsv ON users USING gin(tsv_data);
    SQL

    execute <<-EOS
      CREATE OR REPLACE FUNCTION fill_search_vector_for_users() RETURNS trigger LANGUAGE plpgsql AS $$

      begin
        new.tsv_data :=
          to_tsvector('pg_catalog.english', coalesce(new.first_name, ''))         ||
          to_tsvector('pg_catalog.english', coalesce(new.last_name, ''))          ||
          to_tsvector('pg_catalog.english', coalesce(new.username, ''))           ||
          to_tsvector('pg_catalog.english', coalesce(new.email, ''));

        return new;
      end
      $$;
    EOS

    execute <<-EOS
      CREATE TRIGGER users_search_content_trigger BEFORE INSERT OR UPDATE
        ON users FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_users();
    EOS

    User.find_each(&:touch)
  end

  def down
    execute <<-SQL
      DROP TRIGGER users_search_content_trigger on users;
      DROP FUNCTION fill_search_vector_for_users();
      ALTER TABLE users drop column tsv_data;
    SQL
  end
end
