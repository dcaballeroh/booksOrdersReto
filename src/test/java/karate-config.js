function fn() {
    var config = {
        baseUrl: 'https://simple-books-api.click'
    };
    karate.configure('ssl', true);
    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 10000);
    return config;
}
