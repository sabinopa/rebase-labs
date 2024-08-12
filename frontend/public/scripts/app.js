document.getElementById('token-form').addEventListener('submit', function(event) {
    event.preventDefault();

    const token = document.getElementById('token').value;
    fetch(`/tests/${token}`)
      .then(response => {
        if (!response.ok) {
          throw new Error('Exame não encontrado.');
        }
        return response.json();
      })
      .then(data => {
        const detailsContainer = document.getElementById('exam-details');
        detailsContainer.innerHTML = `
          <h2>Detalhes do Exame</h2>
          <p><strong>Token:</strong> ${data.result_token}</p>
          <p><strong>Data do Resultado:</strong> ${data.result_date}</p>
          <h3>Paciente</h3>
          <p><strong>CPF:</strong> ${data.patient.cpf}</p>
          <p><strong>Nome:</strong> ${data.patient.name}</p>
          <p><strong>Email:</strong> ${data.patient.email}</p>
          <p><strong>Data de Nascimento:</strong> ${data.patient.birthdate}</p>
          <h3>Médico</h3>
          <p><strong>CRM:</strong> ${data.doctor.crm}</p>
          <p><strong>Nome:</strong> ${data.doctor.name}</p>
          <p><strong>Email:</strong> ${data.doctor.email}</p>
          <p><strong>CRM Estado:</strong> ${data.doctor.crm_state}</p>
          <h3>Testes</h3>
          <ul>
            ${data.tests.map(test => `
              <li><strong>Tipo:</strong> ${test.type}, <strong>Limites:</strong> ${test.limits}, <strong>Resultado:</strong> ${test.result}</li>
            `).join('')}
          </ul>
        `;
      })
      .catch(error => {
        const detailsContainer = document.getElementById('exam-details');
        detailsContainer.innerHTML = `<p style="color:red;">${error.message}</p>`;
      });
  });
