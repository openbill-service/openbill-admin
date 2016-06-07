module ButtonsHelper
  def destroy_button(link)
    link_to t('delete'), link, method: :delete, 'data-confirm' => 'Точно удалить?', class: 'btn btn-sm btn-danger'
  end

  def edit_button(link)
    link_to t('edit'), link, class: 'btn btn-sm btn-warning'
  end
end
