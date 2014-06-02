(function(jQuery) {
  jQuery.fn.buildResultAppender = function(options) {
    var options = jQuery.extend({
      label_revision: '', 
      revisions: {} 
    }, options);

    jQuery(document).ready(function() {
      jQuery.each(options.revisions, function(revision, results) {
        anchor = jQuery("div#issue-changesets").find("a").filter(function(){
            return jQuery(this).text().match(options.label_revision + " " + revision);
          }).get(0);
        changeset_refs = jQuery(anchor).parent().next("div.wiki");
        message = jQuery("<p/>", {
                          class: 'hudson-build-results'
                        });
        jQuery.each(results, function() {

          linked_build = jQuery("<a/>", {
                                 class: "built-by",
                                 text: this.jobName + " #" + this.number,
                                 href: this.url
                               });

          styled_result = jQuery("<span/>", {
                                  class: "result " + this.result.toLowerCase(),
                                  style: 'font-weight:bold;',
                                  text:  this.result
                                }); 

          message.append(styled_result);
          message.append(" builded by ");
          message.append(linked_build);
          message.append(" at ");
          message.append(this.finished_at_tag);
          message.append(" ago<br/>");
        });
        changeset_refs.before(message);
      });
    });
  };
})(jQuery);
