require 'test_helper'

class Superadmin::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = create(:event)
    @root = create(:root)
  end

  it_allows_access_to_index_for(%i[root]) do
    get superadmin_events_url
    assert_response :success
  end

  it_allows_access_to_show_for(%i[root]) do
    get superadmin_event_url(@event)
    assert_response :success
  end

  it_allows_access_to_new_for(%i[root]) do
    get new_superadmin_event_url
    assert_response :success
  end

  it_allows_access_to_create_for(%i[root]) do
    assert_difference('Event.count') do
      post superadmin_events_url,
        params: { event: attributes_for(:event) }
    end
  end

  it_allows_access_to_update_for(%i[root]) do
    patch superadmin_event_url(@event),
      params: { event: { name: 'New Test Event Name' } }
  end

  it_allows_access_to_destroy_for(%i[root]) do
    assert_difference('Event.count', -1) do
      delete superadmin_event_url(@event)
    end
  end
end
