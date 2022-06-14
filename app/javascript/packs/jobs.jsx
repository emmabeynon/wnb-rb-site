import React from 'react';
import ReactDOM from 'react-dom';
import Jobs from 'components/pages/Jobs';

document.addEventListener('DOMContentLoaded', () => {
    const body = document.createElement('div');
    body.style = 'min-height: 100vh';

    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const pageNumber = urlParams.get('page');

    ReactDOM.render(<Jobs pageNumber={pageNumber} />, document.body.appendChild(body));
});
