module ButtonsHelper
  def destroy_button(link)
    link_to t('delete'), link, method: :delete, 'data-confirm' => 'Точно удалить?', class: 'btn btn-sm btn-success'
  end
end
