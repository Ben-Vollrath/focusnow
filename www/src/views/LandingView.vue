<script setup lang="ts">
// No logic needed yet
</script>

<template>
  <div class="landing">
    <header>
      <h1>Level Up Your Study Game</h1>
      <p>Timers, challenges, and analytics to stay focused and motivated.</p>
      <div class="cta-buttons">
        <a href="https://play.google.com/store/apps/details?id=io.vollrath.focusnow"
          ><i class="fab fa-android"></i> Download for Android</a
        >
      </div>
    </header>

    <section>
      <h2 class="section-title">Features to Keep You Focused</h2>
      <div class="features">
        <div class="feature">
          <i class="fas fa-clock"></i>
          <h3>Smart Study Timers</h3>
          <p>Choose from Pomodoro, Endless, or 90/30 modes to fit your focus style.</p>
        </div>
        <div class="feature">
          <i class="fas fa-level-up-alt"></i>
          <h3>Leveling System</h3>
          <p>Earn XP as you study and climb the ranks. Stay motivated with every session.</p>
        </div>
        <div class="feature">
          <i class="fas fa-bolt"></i>
          <h3>Challenges</h3>
          <p>Complete daily and long-term challenges to earn rewards and stay engaged.</p>
        </div>
        <div class="feature">
          <i class="fas fa-chart-line"></i>
          <h3>Analytics Dashboard</h3>
          <p>See how much you’ve studied, your focus streaks, and session trends over time.</p>
        </div>
        <div class="feature">
          <i class="fas fa-bullseye"></i>
          <h3>Custom Goals</h3>
          <p>Set personal goals like "100 hours this month" and track your progress visually.</p>
        </div>
      </div>
    </section>

    <section class="how-it-works">
      <h2 class="section-title">How It Works</h2>
      <div class="steps">
        <div>
          <h4>1. Choose Your Timer</h4>
          <p>Select a focus mode that fits your energy.</p>
        </div>
        <div>
          <h4>2. Start Studying</h4>
          <p>Stay distraction-free and build streaks.</p>
        </div>
        <div>
          <h4>3. Earn XP & Track Progress</h4>
          <p>Unlock levels, view stats, and keep the momentum going.</p>
        </div>
      </div>
    </section>

    <section class="testimonials">
      <h2 class="section-title">What Our Users Say</h2>
      <div class="steps">
        <div class="testimonial">
          <p>“FocusNow made studying actually fun. I never miss a streak!” – Emma, Student</p>
        </div>
        <div class="testimonial">
          <p>“The XP system and challenges keep me going every single day.” – Jay, Uni Prep</p>
        </div>
        <div class="testimonial">
          <p>
            “I love seeing how many hours I’ve studied – it’s super motivating!” – Lena, Grad
            Student
          </p>
        </div>
      </div>
    </section>

    <section class="comparison">
      <h2 class="section-title">Why FocusNow?</h2>
      <div class="comparison-table">
        <table>
          <thead>
            <tr>
              <th>Feature</th>
              <th>FocusNow</th>
              <th>Other Apps</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Study Timers</td>
              <td>✅</td>
              <td>✅</td>
            </tr>
            <tr>
              <td>XP & Leveling</td>
              <td>✅</td>
              <td>❌</td>
            </tr>
            <tr>
              <td>Progress Analytics</td>
              <td>✅</td>
              <td>❌</td>
            </tr>
            <tr>
              <td>Challenges</td>
              <td>✅</td>
              <td>❌</td>
            </tr>
            <tr>
              <td>Personalized Goals</td>
              <td>✅</td>
              <td>❌</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="cta-section">
      <h2>Ready to Stay Focused?</h2>
      <p>Download FocusNow today and start leveling up your productivity.</p>
      <br />
      <a href="https://play.google.com/store/apps/details?id=io.vollrath.focusnow"
        ><i class="fab fa-android"></i> Get FocusNow Free</a
      >
    </section>

    <footer>
      <p>&copy; 2025 FocusNow. All rights reserved.</p>
    </footer>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
.landing {
  font-family: 'Inter', sans-serif;
  background: #0e0e10;
  color: #f5f5f5;
  line-height: 1.6;
}
header {
  background: #a259ff;
  color: #ffffff;
  padding: 4rem 2rem;
  text-align: center;
}
header h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}
header p {
  font-size: 1.25rem;
  margin-bottom: 2rem;
}
.cta-buttons a {
  text-decoration: none;
  background: #ffffff;
  color: #a259ff;
  font-weight: 600;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  margin: 0 0.5rem;
  display: inline-block;
}
section {
  padding: 4rem 2rem;
  max-width: 960px;
  margin: 0 auto;
}
.section-title {
  text-align: center;
  margin-bottom: 2rem;
  color: #efefff;
}
.features {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 2rem;
}
.feature {
  background: #2a2a2e;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}
.feature h3 {
  margin-bottom: 0.5rem;
  color: #7f5af0;
}
.feature i {
  font-size: 1.5rem;
  color: #a259ff;
  margin-bottom: 0.75rem;
  display: inline-block;
}
.how-it-works,
.testimonials,
.comparison {
  margin-top: 4rem;
}
.steps,
.comparison-table {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-top: 2rem;
}
.steps div,
.testimonial {
  background: #2a2a2e;
  padding: 1.5rem;
  border-radius: 12px;
}
.steps div h4 {
  color: #a259ff;
}
.testimonial p {
  font-style: italic;
}
.comparison-table table {
  width: 100%;
  border-collapse: collapse;
  background: #2a2a2e;
  border-radius: 12px;
  overflow: hidden;
}
.comparison-table th,
.comparison-table td {
  padding: 1rem;
  text-align: center;
  border: 1px solid #444;
}
.comparison-table th {
  background-color: #1a1a1d;
  color: #efefff;
}
.comparison-table td {
  color: #f5f5f5;
}
.cta-section {
  text-align: center;
  background: #1a1a1d;
  padding: 4rem 2rem;
}
.cta-section h2 {
  font-size: 2rem;
  margin-bottom: 1rem;
  color: #efefff;
}
.cta-section a {
  background: #a259ff;
  color: #ffffff;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 600;
}
footer {
  text-align: center;
  padding: 2rem;
  background: #1a1a1d;
  font-size: 0.9rem;
  color: #f5f5f5;
}
</style>
