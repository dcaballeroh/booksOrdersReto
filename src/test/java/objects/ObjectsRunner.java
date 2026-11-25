package objects;

import com.intuit.karate.junit5.Karate;

class ObjectsRunner {

    @Karate.Test
    Karate testObjects() {
        return Karate.run("books-orders").relativeTo(getClass());
    }
}
