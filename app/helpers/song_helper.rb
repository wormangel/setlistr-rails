module SongHelper
  def label_for_discoverable_field(label)
    (label + ' ' + '<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>').html_safe
  end
end