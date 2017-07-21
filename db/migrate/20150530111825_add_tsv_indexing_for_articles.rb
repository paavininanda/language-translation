class AddTsvIndexingForArticles < ActiveRecord::Migration
  def up
    add_column :articles, :tsv_data, :tsvector

    ## Adds an index for this new column
    execute <<-SQL
      CREATE INDEX index_articles_tsv ON articles USING gin(tsv_data);
    SQL

    execute <<-EOS
      CREATE OR REPLACE FUNCTION fill_search_vector_for_articles() RETURNS trigger LANGUAGE plpgsql AS $$

      begin
        new.tsv_data :=
          to_tsvector('pg_catalog.english', coalesce(new.english, ''))    ||
          to_tsvector('pg_catalog.english', coalesce(new.phonetic, ''));

        return new;
      end
      $$;
    EOS

    execute <<-EOS
      CREATE TRIGGER articles_search_content_trigger BEFORE INSERT OR UPDATE
        ON articles FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_articles();
    EOS

    Article.find_each(&:touch)
  end

  def down
    execute <<-SQL
      DROP TRIGGER articles_search_content_trigger on articles;
      DROP FUNCTION fill_search_vector_for_articles();
      ALTER TABLE articles drop column tsv_data;
    SQL
  end
end
