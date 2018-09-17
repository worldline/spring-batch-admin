function saveComment(url, id) {
    console.log('my id', id);
    console.log('my url', url);
    $.ajax({
        type: 'POST',
        url: url + '/saveComment',
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        data: $('#saveForm' + id).serialize(),
        dataType: 'text',
        fail: function () {
            alert('Problème lors de la sauvegarde du commentaire.');
        }
    });
}