# A batch for processing Solr records
#
# While indexing Solr documents, here are time and CPU-efficiency gains to be made by inserting
# and committing in bulk. A SolrBatch handles all queuing records an managing batch sizes
# without requiring much housekeeping in the calling code.
#
# Example:
#
#     # Create a default size batch
#     batch = SolrBatch.new
#
#     # Create a batch with custom sizes and sleep behavior
#     batch = SolrBatch.new index_batch_size: 100,
#                         commit_batch_size: 500,
#                         index_sleep_seconds: 1,
#                         commit_sleep_seconds: 5
#
#     # Add some records. Inserts and commits are handled as necessary
#     batch.add(record1)
#     batch.add(record2)
#     ...
#
#     # When you're done, close the batch to make sure all records are indexed and committed.
#     batch.close
class SolrBatch

  # Create a batch
  #
  # @param index_batch_size [Integer] How many records will be added before indexing
  # @param commit_batch_size [Integer] How many records will be added before committing
  # @param index_sleep_seconds [Integer] Seconds to sleep after an indexing
  # @param commit_sleep_seconds [Integer] Seconds to sleep after a commit
  def initialize(index_batch_size: 50, commit_batch_size: 400, index_sleep_seconds: 0, commit_sleep_seconds: 1)

    # Batch sizes
    @insert_batch_size = index_batch_size
    @commit_batch_size = commit_batch_size

    # Batch sleep times
    @index_sleep_seconds = index_sleep_seconds
    @commit_sleep_seconds = commit_sleep_seconds

    # Records queued for inserting
    @insert_batch = []

    # How many records we have queued for committing
    @waiting_to_commit_count = 0
  end

  # Add a record to be indexed and committed
  #
  # @param [Bibliography] record
  def add(record)

    # Add record to list to commit and increment the commit count.
    @insert_batch.push(record)
    @waiting_to_commit_count = @waiting_to_commit_count + 1

    # If we've reached any size limits, index or commit.
    if @insert_batch.length >= @insert_batch_size
      index
    end

    if @waiting_to_commit_count >= @commit_batch_size
      commit
    end

  end

  # Index or commit any remaining records before closing out a batch
  def close
    # Index and commit any remaining records
    index
    commit
  end

  private

  # Index the records
  def index
    Sunspot.index @insert_batch
    @insert_batch = []
    sleep @index_sleep_seconds
  end

  # Commit the records
  def commit
    Sunspot.commit
    @waiting_to_commit_count = 0
    sleep @commit_sleep_seconds
  end
end