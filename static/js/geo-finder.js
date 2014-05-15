$(function() {
  function setLatLong(form, name, lat, long) {
    $('[name=' + name + '_lat]', form).val(lat || '');
    $('[name=' + name + '_long]', form).val(long || '');
  }

  $("[data-geo-finder]").each(function() {
    var name = $(this).attr('name');
    var url = $(this).attr('data-geo-finder');
    var form = $(this).parents('form');
    var formGroup = $(this).parents('.form-group');

    $(this).typeahead({
      hint: true,
      highlight: true,
      minLength: 2
    }, {
      name: name,
      displayKey: 'name',
      source: function findMatches(q, cb) {
        $.getJSON(url, {q: q}, cb);
      }
    }).on('typeahead:selected typeahead:autocompleted', function(e, sugg) {
      setLatLong(form, name, sugg.lat, sugg.long);
      formGroup.removeClass('has-error');
    }).on('input', function() {
      setLatLong(form, name);
      formGroup.toggleClass('has-error', !!$(this).val());
    });

    form.on('submit', function() {
      if (formGroup.hasClass('has-error')) return false;
    }.bind(this));
  });
});
