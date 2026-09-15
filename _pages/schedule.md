---
layout: page
title: Schedule
permalink: /schedule
---

<style>
.schedule-when {
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    gap: 20px;
    background: linear-gradient(135deg, rgb(25, 67, 126), #407E99);
    color: #fff;
    border-radius: 16px;
    padding: 24px 28px;
    margin: 0 auto 40px auto;
    box-shadow: 0 6px 18px rgba(25, 67, 126, 0.25);
}

.schedule-when .emoji {
    font-size: 2.6rem;
    line-height: 1;
}

.schedule-when h3 {
    font-family: Righteous, sans-serif;
    color: rgb(249, 218, 116);
    margin: 0 0 6px 0;
    font-size: 1.3rem;
}

.schedule-when p {
    margin: 0;
    font-size: 1.05rem;
}

@media (max-width: 480px) {
    .schedule-when {
        flex-direction: column;
    }
}

.schedule-timeline {
    position: relative;
    margin: 0 0 30px 0;
    padding-left: 34px;
}

.schedule-timeline::before {
    content: "";
    position: absolute;
    left: 10px;
    top: 8px;
    bottom: 8px;
    width: 3px;
    background: repeating-linear-gradient(
        to bottom,
        #ff8b52 0,
        #ff8b52 8px,
        transparent 8px,
        transparent 16px
    );
    border-radius: 3px;
}

.schedule-item {
    position: relative;
    background: #fff;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 14px 18px;
    margin-bottom: 14px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.schedule-item:hover {
    transform: translateX(4px);
    box-shadow: 0 4px 14px rgba(0, 0, 0, 0.1);
}

.schedule-item::before {
    content: "";
    position: absolute;
    left: -30px;
    top: 20px;
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: #407E99;
    border: 3px solid #fff;
    box-shadow: 0 0 0 2px #407E99;
}

.schedule-item.is-off::before {
    background: rgb(249, 218, 116);
    box-shadow: 0 0 0 2px rgb(249, 218, 116);
}

.schedule-item .schedule-date {
    display: inline-block;
    font-family: Righteous, sans-serif;
    color: rgb(25, 67, 126);
    font-size: 1.1rem;
    min-width: 60px;
}

.schedule-item .schedule-topic {
    font-weight: 700;
    color: #333;
}

.schedule-item .schedule-presenter {
    color: #777;
    font-style: italic;
}

.schedule-item.is-off {
    background: #fafafa;
    color: #999;
}

.schedule-item.is-off .schedule-topic {
    color: #999;
    font-weight: 400;
    font-style: italic;
}

.schedule-note {
    margin-top: 30px;
    padding: 16px 20px;
    border-radius: 12px;
    background: #fff8ec;
    border: 1px dashed #ff8b52;
    color: #555;
}

.schedule-note a {
    color: rgb(25, 67, 126);
    font-weight: 700;
    text-decoration: underline;
}

.schedule-note a:hover {
    color: #407E99;
}
</style>

<div class="col-md-10 pr-5">

<p>Swing by and grab a coffee &mdash; here's when and where we're meeting, plus what's on deck. 🧠✨</p>

<div class="schedule-when">
    <div class="emoji">📍</div>
    <div>
        <h3>Every other Friday, 3:30&ndash;4:30 pm</h3>
        <p>LSRC, Room B240 &mdash; and on Zoom for anyone joining remotely!</p>
    </div>
</div>

<h4>Fall 2026</h4>

<div class="schedule-timeline">

  <div class="schedule-item">
    <span class="schedule-date">9/4</span> &mdash;
    <span class="schedule-topic">Organizational Meeting</span>
    <span class="schedule-presenter">(Deb / Kaylee / Jaime)</span>
  </div>

  <div class="schedule-item">
    <span class="schedule-date">9/18</span> &mdash;
    <span class="schedule-topic">Making a Personal Website</span>
    <span class="schedule-presenter">(Alissa Rivero)</span>
  </div>

  <div class="schedule-item">
    <span class="schedule-date">10/2</span> &mdash;
    <span class="schedule-topic">Structural Topic Modeling</span>
    <span class="schedule-presenter">(Deborah Cesarini)</span>
  </div>

  <div class="schedule-item">
    <span class="schedule-date">10/16</span> &mdash;
    <span class="schedule-topic">Automating Research</span>
    <span class="schedule-presenter">(Jade Terry)</span>
  </div>

  <div class="schedule-item">
    <span class="schedule-date">10/30</span> &mdash;
    <span class="schedule-topic">Automating Research</span>
    <span class="schedule-presenter">(Jade Terry)</span>
  </div>

  <div class="schedule-item is-off">
    <span class="schedule-date">11/13</span> &mdash;
    <span class="schedule-topic">No meeting &mdash; SSSP Conference</span>
  </div>

  <div class="schedule-item">
    <span class="schedule-date">11/20</span> &mdash;
    <span class="schedule-topic">Open Slot for Workshop</span>
  </div>

  <div class="schedule-item is-off">
    <span class="schedule-date">11/27</span> &mdash;
    <span class="schedule-topic">No Meeting &mdash; Happy Thanksgiving! 🦃</span>
  </div>

  <div class="schedule-item">
    <span class="schedule-date">12/4</span> &mdash;
    <span class="schedule-topic">Open Slot for Workshop</span>
  </div>

</div>

<div class="schedule-note">
💡 Want to lead a workshop or fill an open slot? Reach out to Deborah Cesarini at <a href="mailto:deborah.cesarini@duke.edu">deborah.cesarini@duke.edu</a>.
</div>

</div>
