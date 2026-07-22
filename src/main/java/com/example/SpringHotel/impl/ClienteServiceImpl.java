package com.example.SpringHotel.impl;

import com.example.SpringHotel.entity.Cliente;
import com.example.SpringHotel.repository.ClienteRepository;
import com.example.SpringHotel.service.IClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClienteServiceImpl implements IClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    @Override
    public List<Cliente> listarTodo() {
        return clienteRepository.findAll();
    }

    @Override
    public Optional<Cliente> buscarPorId(Integer id) {
        return clienteRepository.findById(id);
    }

    @Override
    public Cliente guardar(Cliente cliente) {
        Optional<Cliente> existente = clienteRepository.findByDniRuc(cliente.getDniRuc());
        if (existente.isPresent()) {
            throw new RuntimeException("Ya existe un cliente registrado con el DNI/RUC: " + cliente.getDniRuc());
        }
        return clienteRepository.save(cliente);
    }

    @Override
    public Cliente actualizar(Integer id, Cliente clienteDetalles) {
        Optional<Cliente> clienteOptional = clienteRepository.findById(id);
        if (clienteOptional.isPresent()) {

            // CORREGIDO: si el DNI/RUC cambió, valida que el nuevo DNI no le pertenezca
            // a OTRO cliente distinto. Sin este chequeo, se podía editar un cliente y
            // asignarle el DNI de otro registro ya existente.
            Optional<Cliente> clienteConEseDni = clienteRepository.findByDniRuc(clienteDetalles.getDniRuc());
            if (clienteConEseDni.isPresent() && !clienteConEseDni.get().getIdCliente().equals(id)) {
                throw new RuntimeException("Ya existe otro cliente registrado con el DNI/RUC: " + clienteDetalles.getDniRuc());
            }

            Cliente clienteExistente = clienteOptional.get();
            clienteExistente.setDniRuc(clienteDetalles.getDniRuc());
            clienteExistente.setNombres(clienteDetalles.getNombres());
            clienteExistente.setApellidos(clienteDetalles.getApellidos());
            clienteExistente.setTelefono(clienteDetalles.getTelefono());
            clienteExistente.setEmail(clienteDetalles.getEmail());
            clienteExistente.setEstado(clienteDetalles.isEstado());
            return clienteRepository.save(clienteExistente);
        } else {
            throw new RuntimeException("Cliente no encontrado con el ID: " + id);
        }
    }

    @Override
    public void eliminar(Integer id) {
        Optional<Cliente> clienteOptional = clienteRepository.findById(id);
        if (clienteOptional.isPresent()) {
            Cliente cliente = clienteOptional.get();
            cliente.setEstado(false);
            clienteRepository.save(cliente);
        } else {
            throw new RuntimeException("No se puede eliminar. Cliente no encontrado con el ID: " + id);
        }
    }
}