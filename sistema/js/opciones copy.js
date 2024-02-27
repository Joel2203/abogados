const options = document.querySelectorAll('.circu');

    options.forEach(option => {
      option.addEventListener('click', () => {
        options.forEach(opt => opt.classList.remove('selected'));
        option.classList.add('selected');
        console.log(option.innerText);
      });
    });