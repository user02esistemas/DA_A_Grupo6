package com.example.SpringHotel.service;

import com.example.SpringHotel.entity.Cliente;
import java.util.List;
import java.util.Optional;

public interface IClienteService {
    List<Cliente> listarTodo();
    Optional<Cliente> buscarPorId(Integer id);
    Cliente guardar(Cliente cliente);
    Cliente actualizar(Integer id, Cliente cliente);
    void eliminar(Integer id);
}