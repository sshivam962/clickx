clickxApp.factory('Businesses', [
  '$resource',
  function ($resource) {
    return $resource(
      '/businesses.json',
      {},
      {
        query: { method: 'GET', params: { page: '@page' }, isArray: true },
        archived: {
          url: '/businesses/archived_list.json',
          params: { search: '', page: '1' },
          method: 'GET',
        },
        create: { method: 'POST' },
        adword_campaigns: {
          url: '/b/google_ads/campaigns.json',
          method: 'GET',
          params: { client_id: '@client_id', id: '@id', type: '@type' },
        },
        campaign_locations: {
          url: '/businesses/adwords/campaign_locations.json',
          method: 'GET',
          params: { client_id: '@client_id', id: '@id', type: '@type' },
        },
        save_adword_campaign_ids: {
          url: '/b/google_ads/update_connected_campaigns.json',
          method: 'POST',
          params: { id: '@id' },
        },
        get_business_report: {
          url: '/businesses/get_business_report.json',
          method: 'GET',
        },
        set_google_auth_paths: {
          url: '/businesses/set_google_auth_paths.json',
          method: 'GET',
        },
        get_site_ids: {
          url: '/businesses/get_site_ids.json',
          method: 'GET',
          isArray: true,
          ignoreLoadingBar: true,
        },
        get_total_labels: {
          url: '/businesses/get_total_labels.json',
          method: 'GET',
        },
        reinitilize_labels_set: {
          url: '/businesses/set_labels.json',
          method: 'GET',
          params: { label_names: '@label_names' },
        },
        get_all_ownable_businesses: {
          url: 'businesses/ownable_businesses_list',
          method: 'GET',
          isArray: true,
        },
        send_support_email: {
          url: 'businesses/send_support_email',
          method: 'POST',
        },
      }
    );
  },
]);

clickxApp.factory('Business', [
  '$resource',
  function ($resource) {
    return $resource(
      '/businesses/:id.json',
      {},
      {
        show: { method: 'GET' },
        all_info: {
          url: '/businesses/:id/all_info.json',
          method: 'GET',
          params: { id: '@id' },
        },
        update: { method: 'PUT', params: { id: '@id' } },
        update_business: {
          url: '/businesses/:id/update_business.json',
          method: 'PUT',
          params: { id: '@id' },
        },
        delete: { method: 'DELETE', params: { id: '@id' } },
        unarchive: {
          url: '/businesses/:id/unarchive.json',
          method: 'GET',
          params: { id: '@id' },
          isArray: true,
        },
        force_delete: {
          url: '/businesses/:id/force_delete.json',
          method: 'GET',
          params: { id: '@id' },
          isArray: true,
        },
        get_calls: {
          url: '/businesses/:id/get_calls.json',
          method: 'GET',
          params: { id: '@id', start: '@start', end: '@end' },
        },
        get_call_details: {
          url: '/businesses/:id/call_details/:call_id.json',
          method: 'GET',
          params: { id: '@id', call_id: '@call_id' },
        },
        get_call_audio: {
          url: '/businesses/:id/call_audio/:call_id.json',
          method: 'GET',
          params: { id: '@id', call_id: '@call_id' },
        },
        // google_analytics_goals: {
        //   url: '/businesses/:id/google_goal_analytics.json',
        //   method: 'GET',
        //   params: { id: '@id' },
        // },
        google_search_console: {
          url: '/businesses/:id/google_search_console.json',
          method: 'GET',
          params: { id: '@id' },
        },
        google_search_console_pages: {
          url: '/businesses/:id/google_search_console_pages.json',
          method: 'GET',
          params: { id: '@id' },
        },
        google_acquisition_campaigns: {
          url: '/businesses/:id/google_acquisition_campaigns.json',
          method: 'GET',
          params: { id: '@id' },
        },
        google_source_medium: {
          url: '/businesses/:id/google_source_medium.json',
          method: 'GET',
          params: { id: '@id' },
        },
        crawl_errors: {
          url: '/businesses/:id/crawl_errors.json',
          method: 'GET',
          params: { id: '@id' },
        },
        sitemaps: {
          url: '/businesses/:id/sitemaps.json',
          method: 'GET',
          params: { id: '@id' },
        },
        adword_summary: {
          url: '/b/google_ads/summary.json',
          method: 'GET',
          params: { id: '@id' },
        },
        adword_keyword: {
          url: '/b/google_ads/keywords.json',
          method: 'GET',
          params: { id: '@id' },
        },
        adword_ads: {
          url: '/b/google_ads/ads.json',
          method: 'GET',
          params: { id: '@id' },
        },
        adword_queries: {
          url: '/b/google_ads/search_terms.json',
          method: 'GET',
          params: { id: '@id' },
        },
        clear_yext_cache: {
          url: '/businesses/:id/clear_yext_cache.json',
          method: 'GET',
          params: { id: '@id' },
        },
        backlinks: {
          url: '/businesses/:id/backlinks.json',
          method: 'GET',
          params: { id: '@id' },
        },
        backlinks_summary: {
          url: '/businesses/:id/backlinks_summary.json',
          method: 'GET',
          params: { id: '@id' },
        },
        top_pages: {
          url: '/businesses/:id/top_pages.json',
          method: 'GET',
          params: { id: '@id' },
        },
        anchor_text: {
          url: '/businesses/:id/anchor_text.json',
          method: 'GET',
          params: { id: '@id' },
        },
        anchor_text_page: {
          url: '/businesses/:id/anchor_text_page.json',
          method: 'GET',
          params: { id: '@id' },
        },
        topics: {
          url: '/businesses/:id/topics.json',
          method: 'GET',
          params: { id: '@id' },
        },
        ref_domains: {
          url: '/businesses/:id/ref_domains.json',
          method: 'GET',
          params: { id: '@id' },
        },
        anchor_word_cloud: {
          url: '/businesses/:id/anchor_text_word_cloud.json',
          method: 'GET',
          params: { id: '@id' },
        },
        crawl_summary: {
          url: '/businesses/:id/crawl_summary.json',
          method: 'GET',
          params: { id: '@id' },
        },
        crawl_graph_summary: {
          url: '/businesses/:id/site_audit_graph_data.json',
          method: 'GET',
          params: { id: '@id' },
        },
        crawl_issues: {
          url: '/businesses/:id/site_audit_issues_data.json',
          method: 'GET',
          params: { id: '@id' },
        },
        crawl_changes: {
          url: 'businesses/:id/site_audit_change_data.json',
          method: 'GET',
          params: { id: '@id' },
        },
        site_audit_detail_page: {
          url: '/businesses/:id/site_audit_detail_page',
          method: 'GET',
          params: { id: '@id', report_id: '@report_id' },
        },
        update_logo: {
          url: '/businesses/:id/update_logo.json',
          method: 'PUT',
          params: { id: '@id' },
        },
        add_to_keyword_bank: {
          url: '/businesses/:id/add_to_keyword_bank.json',
          method: 'POST',
          params: { id: '@id' },
        },
        business_keywords: {
          url: '/businesses/:id/business_keywords.json',
          method: 'GET',
          params: { id: '@id' },
          isArray: false,
          ignoreLoadingBar: true,
        },
        competitor_ranks: {
          url: '/businesses/:id/competitor_ranks.json',
          method: 'GET',
          params: { id: '@id', keyword_name: '@name' },
        },
        delete_business_keyword: {
          url: '/businesses/:id/delete_business_keyword.json',
          method: 'POST',
          params: { id: '@id' },
        },
        get_datewise_rankings: {
          url: '/businesses/:id/get_datewise_rankings.json',
          method: 'GET',
          params: { id: '@id', date_string: '@date_string' },
        },
        tag_keywords: {
          url: '/businesses/tags/tag_keywords.json',
          method: 'POST',
        },
        all_keyword_tags: { url: '/businesses/tags/index', method: 'GET' },
        keywords_in_tag: { url: '/businesses/tags/keywords', method: 'GET' },
        new_keyword_tag: { url: '/businesses/tags/create', method: 'POST' },
        edit_keyword_tag: { url: '/businesses/tags/update', method: 'PUT' },
        keyword_locations: {
          url: '/businesses/keyword_locations',
          method: 'GET',
        },
        keywords_list: {
          url: '/businesses/:id/keywords_list',
          method: 'GET',
          params: { id: '@id' },
          isArray: true,
        },
        keyword_suggestions: {
          url: '/businesses/:id/keyword_suggestions',
          method: 'GET',
          params: { id: '@id' },
        },
        untag_business_keyword: {
          url: '/businesses/tags/untag_business_keyword',
          method: 'POST',
        },
        busisess_cards_list: { url: '/payment_details', method: 'GET' },
        business_card_delete: {
          url: '/payment_details/:id',
          method: 'DELETE',
          params: { id: '@id' },
        },
        edit_keyword: {
          url: '/businesses/:id/edit_keyword.json',
          method: 'POST',
          params: { id: '@id' },
        },
        add_domain: {
          url: '/businesses/:id/add_domain.json',
          method: 'POST',
          params: { id: '@id' },
        },
        delete_keyword_tag: {
          url: '/businesses/tags/destroy',
          method: 'DELETE',
        },
        update_timezone: {
          url: '/businesses/:id/update_timezone.json',
          method: 'POST',
          params: { timezone: '@timezone', id: '@id' },
        },
        activity_list: {
          url: '/businesses/:id/activity_list.json',
          method: 'GET',
          params: { id: '@id', per_page: '@per_page', page: '@page' },
          isArray: false,
        },
        reviews_by_stars: {
          url: '/businesses/:id/reviews_stars.json',
          method: 'GET',
          params: { id: '@id' },
        },
        marketing_performance: {
          url: '/businesses/:id/marketing_performance.json',
          method: 'GET',
          params: {
            id: '@id',
            date_range: '@date_range',
            compared_to: '@compared_to',
          },
        },
        marketing_performance_goal: {
          url: '/businesses/:business_id/marketing_performance_goal.json',
          method: 'GET',
          params: { business_id: '@business_id' },
        },
        set_marketing_performance_goal: {
          url: '/businesses/:business_id/marketing_performance_goal.json',
          method: 'POST',
          params: {
            business_id: '@business_id',
            visits_per_month: '@visits_per_month',
            contacts_per_month: '@contacts_per_month',
            customers_pre_month: '@customers_pre_month',
          },
        },
        update_marketing_performance_goal: {
          url: '/businesses/:business_id/marketing_performance_goal.json',
          method: 'PUT',
          params: {
            business_id: '@business_id',
            visits_per_month: '@visits_per_month',
            contacts_per_month: '@contacts_per_month',
            customers_pre_month: '@customers_pre_month',
          },
        },
        reset_marketing_performance_goal: {
          url: '/businesses/:business_id/marketing_performance_goal.json',
          method: 'DELETE',
          params: { business_id: '@business_id', user: '@user' },
        },
        business_users: {
          url: '/businesses/:id/business_users.json',
          method: 'GET',
          params: { id: '@id' },
          isArray: true,
        },
        set_budget: {
          url: '/businesses/:id/set_budget.json',
          method: 'POST',
          params: { id: '@id' },
        },
        deleted_business_keywords: {
          url: '/businesses/deleted_business_keywords.json',
          method: 'GET',
        },
        rank_summaries: {
          url: '/businesses/:id/rank_summaries.json',
          method: 'GET',
          isArray: true,
          params: {
            id: '@id',
            duration: '@duration',
            engine: '@engine',
            date_clicked: '@date_clicked',
            range: '@range',
          },
        },
        all_intelligence: {
          url: '/businesses/intelligence/:id/all.json',
          method: 'GET',
          params: { id: '@id' },
        },
        dashlet_intelligence: {
          url: '/businesses/intelligence/:id/:method.json',
          method: 'GET',
          params: { id: '@id', method: '@method' },
        },
        current_business_dashboard: {
          url: '/current_business_dashboard.json',
          method: 'GET',
        },
        new_backlinks: {
          url: '/businesses/:id/new_backlinks.json',
          method: 'GET',
          params: { id: '@id', tracked_date: '@tracked_date' },
        },
        lost_backlinks: {
          url: '/businesses/:id/lost_backlinks.json',
          method: 'GET',
          params: { id: '@id', tracked_date: '@tracked_date' },
        },
        backlinks_history: {
          url: '/businesses/:id/backlinks_history.json',
          method: 'GET',
          params: { id: '@id' },
        },
        adwords_connect_account: {
          url: 'businesses/adwords/connect_account',
          method: 'GET',
          isArray: true,
        },
        adwords_disconnect: {
          url: 'b/google_ads/disconnect',
          method: 'PUT',
        },
        disconnect_google_search_console: {
          method: 'DELETE',
          url: '/google_search_console/disconnect',
        },
        disconnect_google_analytics: {
          method: 'DELETE',
          url: '/google_analytics/disconnect',
        },
        current_plan: {
          url: '/businesses/billing/current_plan',
          method: 'GET',
        },
        fetch_cards: { url: '/businesses/billing/fetch_cards', method: 'GET' },
        subscribe: { url: '/businesses/billing/subscribe', method: 'POST' },
        update_card: { url: '/businesses/billing/update_card', method: 'POST' },
        update_customer: {
          url: '/businesses/billing/update_customer',
          method: 'POST',
        },
        add_subscription_account: {
          url: '/businesses/billing/add_subscription_account',
          method: 'POST',
        },
        cancel_downgrade: {
          url: '/businesses/billing/cancel_downgrade',
          method: 'POST',
        },
        subscribe_to_free: {
          url: 'businesses/billing/subscribe_to_free',
          method: 'POST',
        },
        active_campaign_integrate: {
          url: '/businesses/active_campaign/connect',
          method: 'POST',
        },
        active_campaign_destroy: {
          url: '/businesses/active_campaign/disconnect',
          method: 'DELETE',
        },
        connect_call_rail: {
          url: 'businesses/callrail/connect',
          method: 'POST',
        },
        call_rail_accounts: {
          url: 'businesses/callrail/all_accounts',
          method: 'GET',
        },
        callrail_data: {
          url: 'businesses/callrail/data',
          method: 'GET',
          params: { start_date: '@start_date', end_date: '@end_date' },
        },
        callrail_call_recording: {
          url: 'businesses/callrail/recording',
          method: 'GET',
        },
        callrail_authenticate: { url: '/businesses/callrail', method: 'POST' },
        wishlist_keywords: {
          url: '/businesses/:id/wishlist_keywords.json',
          method: 'GET',
        },
        integration_details: {
          url: '/businesses/:id/integration_detail.json',
          method: 'GET',
          params: { id: '@id' },
        },
        country_locale: { url: '/locales', method: 'GET' },
        update_keyword: { url: 'businesses/update_keyword', method: 'POST' },
      }
    );
  },
]);

clickxApp.factory('traction', [
  '$resource',
  function ($resource) {
    return $resource(
      '/',
      {},
      {
        client_traction: {
          url: '/businesses/client_traction.json',
          method: 'POST',
        },
      }
    );
  },
]);

/**
 *  Return promises {object: list}
 */
clickxApp.service('BusinessKeywordCheckList', [
  '$q',
  'Business',
  function ($q, Business) {
    this.getList = function (id, list) {
      var id = id || 27;
      var list = list || [];
      return $q(function (result, reject) {
        try {
          Business.keywords_list({ id: id }, function (result_keywords) {
            var newListArray = result_keywords;
            list = _.map(list, function (value, index) {
              _.each(newListArray, function (value2, index2) {
                var checkName =
                  value.name || value.query || value.keyword || value.keys;
                try {
                  if (checkName.toLowerCase() == value2.name) {
                    value['keyword_exist'] = true;
                    value['keyword_id'] = value2.id;
                  } else {
                  }
                } catch (e) {
                  console.log(e);
                }
              });
              return value;
            });
          });
          if (list.length > 0) {
            result(list); // if list if not empty
          } else {
            reject(list);
          }
        } catch (e) {
          reject(null);
        }
      });
    };
  },
]);
