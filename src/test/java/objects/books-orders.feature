Feature: Automatización CRUD y Autenticación en Simple Books API

  Background:
    * url baseUrl
    * def orderSchema =
      """
      {
        id: '#string',
        bookId: '#number',
        customerName: '#string',
        quantity: '#number',
        timestamp: '#number'
      }
      """

  Scenario: Flujo completo con Token dinámico, POST, GET, PATCH y DELETE
    # 1. GET - Verificar estado de la API
    Given path 'status'
    When method get
    Then status 200
    And match response == { status: 'OK' }

    # 2. GET - Consultar libros disponibles (con query param) y obtener un bookId dinámico
    Given path 'books'
    And param type = 'fiction'
    And param limit = 5
    When method get
    Then status 200
    And match response == '#[]'
    And match each response ==
      """
      {
        id: '#number',
        name: '#string',
        type: 'fiction',
        available: '#boolean'
      }
      """
    * def availableBooks = karate.filter(response, function(x){ return x.available == true })
    * def selectedBookId = availableBooks[0].id
    * karate.log('Libro disponible seleccionado ID:', selectedBookId)

    # 3. POST - Registrar cliente dinámico para obtener Bearer Token (evita error 409)
    * def unique = java.lang.System.currentTimeMillis()
    Given path 'api-clients'
    And request
      """
      {
        "clientName": "#('Cliente' + unique)",
        "clientEmail": "#('david' + unique + '@example.com')"
      }
      """
    When method post
    Then status 201

    And match response == { accessToken: '#string' }
    * def token = 'Bearer ' + response.accessToken

    # 4. POST - Crear una nueva orden usando el token y el bookId dinámico
    Given path 'orders'
    And header Authorization = token
    And request
      """
      {
    "bookId": #(selectedBookId),
    "customerName": "David Caballero"
    }
    """
    When method post
    Then status 201
    And match response == { created: true, orderId: '#string' }
    * def createdOrderId = response.orderId
    * karate.log('Orden creada con ID:', createdOrderId)

    # 5. GET - Consultar la orden creada por su ID y validar estructura y datos
    Given path 'orders', createdOrderId
    And header Authorization = token
    When method get
    Then status 200
    And match response == orderSchema
    And match response.id == createdOrderId
    And match response.bookId == selectedBookId
    And match response.customerName == 'David Caballero'

    # 6. PATCH - Actualizar el nombre del cliente en la orden
    Given path 'orders', createdOrderId
    And header Authorization = token
    And request { "customerName": "David Caballero Actualizado" }
    When method patch
    Then status 204

    # 7. GET - Verificar que la actualización se aplicó correctamente
    Given path 'orders', createdOrderId
    And header Authorization = token
    When method get
    Then status 200
    And match response.customerName == 'David Caballero Actualizado'

    # 8. DELETE - Eliminar la orden existente
    Given path 'orders', createdOrderId
    And header Authorization = token
    When method delete
    Then status 204

    # 9. GET - Confirmar que la orden eliminada ya no existe (404)
    Given path 'orders', createdOrderId
    And header Authorization = token
    When method get
    Then status 404
    And match response.error contains createdOrderId
